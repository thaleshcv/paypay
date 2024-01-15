# frozen_string_literal: true

# Entry model.
class Entry < ApplicationRecord
  enum :operation, %i[income outgoing]

  attribute :value, :money

  belongs_to :category, inverse_of: :entries
  belongs_to :user, inverse_of: :entries

  validates_presence_of :operation, :title, :date, :value

  def signed_value
    outgoing? ? -value : value
  end
end
