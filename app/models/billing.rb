# frozen_string_literal: true

# Billing model.
class Billing < ApplicationRecord
  enum :status, %i[active suspended], prefix: true

  belongs_to :user, inverse_of: :billings
  has_many :entries, inverse_of: :billing

  validates_presence_of :description, :due_date, :cycles
  validates_numericality_of :cycles, only_integer: true, in: (1..12)
  validates_numericality_of :due_date, only_integer: true, in: (1..25)

  after_commit :create_missing_entries, on: :create

  def first_entry
    entries.order(date: :asc).first
  end

  def last_entry
    entries.where_date_before_today.order(date: :desc).first
  end

  def create_missing_entries
    raise NoEntryFoundError, "No entry found for this billing" if entries.count.zero?

    example_entry = last_entry
    entry_date = Date.new(example_entry.date.year, example_entry.date.month, due_date)
    date_limit = Date.today + 15.days

    while cycles == 1 || (cycles > 1 && entries_count < cycles)
      entry_date = entry_date.next_month

      break if entry_date > date_limit

      starting, ending = entry_date.all_month.minmax

      next unless entries.where_date_between(starting.beginning_of_day, ending.end_of_day).count.zero?

      entries.create(
        user_id: user_id,
        category_id: example_entry.category_id,
        description: "#{Billing.model_name.human} - #{example_entry.description}",
        value: example_entry.value,
        status: "pending",
        date: entry_date
      )
    end
  end

  # Error class for auto-generating entries for billing.
  class NoEntryFoundError < StandardError; end
end
