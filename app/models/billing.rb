# frozen_string_literal: true

# Billing model.
class Billing < ApplicationRecord
  belongs_to :user, inverse_of: :billings
  belongs_to :last_entry, optional: true
  has_many :entries, inverse_of: :billing

  validates_presence_of :description, :due_date, :cycles
  validates_numericality_of :cycles, only_integer: true, in: (1..12)
  validates_numericality_of :due_date, only_integer: true, in: (1..25)
end
