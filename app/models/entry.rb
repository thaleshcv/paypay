# frozen_string_literal: true

# Entry model.
class Entry < ApplicationRecord
  enum :operation, %i[income outgoing]

  belongs_to :category, inverse_of: :entries
  belongs_to :user, inverse_of: :entries

  validates_presence_of :operation, :title, :date, :value

  def signed_value
    income? ? value : -value
  end
end
