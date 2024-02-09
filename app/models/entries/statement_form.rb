# frozen_string_literal: true

module Entries
  # Form object for querying entries.
  class StatementForm < ::ApplicationForm
    # attribute :date, :date, default: Date.today

    # month and year attributes
    attribute :month, :integer, default: Date.today.month
    attribute :year, :integer, default: Date.today.year

    def date
      Date.new(year, month, 1)
    end

    def perform(base_scope)
      starting, ending = date.all_month.minmax
      base_scope.where_date_between(starting.beginning_of_day, ending.end_of_day)
    end
  end
end
