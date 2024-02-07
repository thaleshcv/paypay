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
      starting = date.change(day: 1).beginning_of_day
      ending = date.change(day: -1).end_of_day

      base_scope.where_date_between(starting, ending)
    end
  end
end
