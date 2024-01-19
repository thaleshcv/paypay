# frozen_string_literal: true

module Entries
  # Form object for querying entries.
  class StatementForm < ::ApplicationForm
    attribute :date, :date, default: Date.today

    def perform(base_scope)
      puts "date #{date}"
      starting = date.change(day: 1).beginning_of_day
      ending = date.change(day: -1).end_of_day

      base_scope.where_date_between(starting, ending)
    end
  end
end
