# frozen_string_literal: true

# Entry model.
class Entry < ApplicationRecord
  has_secure_token

  enum :status, %i[pending paid], prefix: true

  attribute :value, :money

  belongs_to :category, inverse_of: :entries, optional: true
  belongs_to :user, inverse_of: :entries
  belongs_to :billing, inverse_of: :entries, optional: true, validate: true

  accepts_nested_attributes_for :billing

  before_validation on: :create do
    billing.user_id = user_id unless billing.nil?
  end

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

  # Returns if the entry has the status of 'pending' and the date is past.
  def overdue?
    status_pending? && date < Date.today
  end

  # Inverts the status of the entry. Pending status turns to paid and vice-versa.
  # Optionally, a hash of attributes can be passed to update alongside the status.
  # If you pass a "status" key in that hash, it will be ignored in favour of the inverse
  # value for the current status.
  def toggle_status(extras = nil)
    extras ||= {}

    new_status = self.class.statuses.keys.tap { |h| h.delete(status) }.first
    fields = extras.reverse_merge({ status: new_status })

    update(fields)
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
