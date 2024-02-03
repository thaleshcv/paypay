module Entries
  class TotalsSummary
    def initialize(entries)
      @entries = entries
    end

    def balance
      @entries.sum(:value)
    end

    private

    attr_reader :entries
  end
end
