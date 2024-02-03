# frozen_string_literal: true

# Entry model.
class Entry < ApplicationRecord
  include FillCurrentUserId

  has_secure_token

  enum :status, %i[pending paid], prefix: true

  attribute :value, :money

  belongs_to :category, inverse_of: :entries, optional: true
  belongs_to :user, inverse_of: :entries
  belongs_to :billing, inverse_of: :entries, optional: true, validate: true

  accepts_nested_attributes_for :billing

  validates_presence_of :description, :date, :value
  validate :cannot_use_category_from_other_user,
    :cannot_use_discarded_category

  scope :where_date_between, lambda { |starting, ending|
    where(date: starting..ending)
  }

  scope :where_date_before, ->(date) { where("date <= ?", date) }
  scope :where_date_before_today, -> { where_date_before(Date.today) }

  # Overrides the default +to_param+ method.
  def to_param = token

  def overdue?
    status_pending? && date < Date.today
  end

  private

  def cannot_use_discarded_category
    return if category_id.blank? || !category.discarded?

    errors.add(:category, :invalid)
  end

  def cannot_use_category_from_other_user
    return if category_id.blank? || category.user_id.blank? || category.user_id == user_id

    errors.add(:category, :invalid)
  end
end
