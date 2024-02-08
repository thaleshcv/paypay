# frozen_string_literal: true

# Billing model.
class Billing < ApplicationRecord
  belongs_to :user, inverse_of: :billings
  has_many :entries, inverse_of: :billing

  validates_presence_of :description, :due_date, :cycles
  validates_numericality_of :cycles, only_integer: true, in: (1..12)
  validates_numericality_of :due_date, only_integer: true, in: (1..25)

  def first_entry
    entries.order(date: :asc).first
  end

  def last_entry
    entries.order(date: :desc).first
  end

  def create_missing_entries
    raise NoEntryFoundError, "No entry found for this billing" if entries.count.zero?

    example_entry = first_entry
    current_date = example_entry.date

    while (cycles == 1 && current_date < Date.today) || (cycles > 1 && entries.count < cycles)
      current_date = current_date.next_month

      starting_date = DateTime.new(current_date.year, current_date.month, 1).beginning_of_day
      ending_date = DateTime.new(current_date.year, current_date.month, -1).end_of_day

      next unless entries.where_date_between(starting_date, ending_date).count.zero?

      entries.create(
        description: example_entry.description,
        value: example_entry.value,
        category_id: example_entry.category_id,
        status: "pending",
        date: Date.new(current_date.year, current_date.month, due_date),
        user_id: user_id
      )
    end
  end

  # Error class for auto-generating entries for billing.
  class NoEntryFoundError < StandardError; end
end
