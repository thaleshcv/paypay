# frozen_string_literal: true

# Category model.
class Category < ApplicationRecord
  has_secure_token

  belongs_to :user, inverse_of: :categories, optional: true

  validates_presence_of :name
  validates_uniqueness_of :name, conditions: -> { where(discarded_at: nil, user_id: [nil, Current.user&.id]) }

  scope :discarded, -> { where.not(discarded_at: nil) }
  scope :not_discarded, -> { where(discarded_at: nil) }

  # Marks the category as discarded by writing +discarded_at+ attribute.
  def discard!
    update_column(:discarded_at, Time.zone.now)
  end

  # Overrides the default +readonly?+ method.
  # Discarded categories and system's categories cannot be edited.
  def readonly?
    persisted? && (discarded_at.present? || user_id.blank?)
  end

  # Overrides the default +to_param+ method.
  def to_param = token

  # Returns +true+ if the category was created by the user, or +false+
  # if is an application's category.
  def user_category? = user_id.present?
end
