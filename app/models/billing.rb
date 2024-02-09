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
    current_entry_date = example_entry.date

    while (cycles == 1 && current_entry_date < Date.today) || (cycles > 1 && entries.count < cycles)
      # ignore the month of the first entry
      current_entry_date = current_entry_date.next_month
      starting, ending = current_entry_date.all_month.minmax

      next unless entries.where_date_between(starting.beginning_of_day, ending.end_of_day).count.zero?

      entries.create(
        user_id: user_id,
        category_id: example_entry.category_id,
        description: "#{Billing.model_name.human} - #{example_entry.description}",
        value: example_entry.value,
        status: "pending",
        date: Date.new(current_entry_date.year, current_entry_date.month, due_date)
      )
    end
  end

  # Error class for auto-generating entries for billing.
  class NoEntryFoundError < StandardError; end
end
