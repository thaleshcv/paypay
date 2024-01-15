# frozen_string_literal: true

# Category model.
class Category < ApplicationRecord
  has_secure_token

  belongs_to :user, inverse_of: :categories, optional: true
  has_many :entries, inverse_of: :category

  validates_presence_of :name
  validates_uniqueness_of :name, conditions: -> { available_for_user(Current.user) }

  scope :discarded, -> { where.not(discarded_at: nil) }
  scope :not_discarded, -> { where(discarded_at: nil) }
  scope :available_for_user, ->(user) { not_discarded.where(user_id: [nil, user]) }

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

  # Returns +true+ if the category was discarded (column +discarded_at+ is set).
  def discarded? = discarded_at.present?
end
