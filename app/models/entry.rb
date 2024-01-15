# frozen_string_literal: true

# Entry model.
class Entry < ApplicationRecord
  has_secure_token

  enum :operation, %i[income outgoing]

  attribute :value, :money

  belongs_to :category, inverse_of: :entries
  belongs_to :user, inverse_of: :entries

  validates_presence_of :operation, :title, :date, :value

  validate :cannot_use_category_from_other_user,
    :cannot_use_discarded_category

  # Overrides the default +to_param+ method.
  def to_param = token

  # Returns a negative value for outgoings.
  def signed_value
    outgoing? ? -value : value
  end

  private

  def cannot_use_discarded_category
    return unless category.discarded?

    errors.add(:category, :invalid)
  end

  def cannot_use_category_from_other_user
    return if category.user_id.blank? || category.user_id == user_id

    errors.add(:category, :invalid)
  end
end
