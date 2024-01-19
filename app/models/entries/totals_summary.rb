module Entries
  class TotalsSummary
    def initialize(entries)
      @entries = entries
    end

    def income_total
      @income_total ||= entries.income.sum(:value)
    end

    def outgoing_total
      @outgoing_total ||= entries.outgoing.sum(:value)
    end

    def balance
      @income_total - @outgoing_total
    end

    private

    attr_reader :entries
  end
end
