# frozen_string_literal: true

# Billing model.
class Billing < ApplicationRecord
  belongs_to :last_entry
  has_many :entries, inverse_of: :billing
end
