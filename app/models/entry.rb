# frozen_string_literal: true

# Entry model.
class Entry < ApplicationRecord
  has_secure_token

  enum :operation, %i[income outgoing]

  attribute :value, :money

  belongs_to :category, inverse_of: :entries
  belongs_to :user, inverse_of: :entries

  validates_presence_of :operation, :title, :date, :value

  # Overrides the default +to_param+ method.
  def to_param = token

  # Returns a negative value for outgoings.
  def signed_value
    outgoing? ? -value : value
  end
end
