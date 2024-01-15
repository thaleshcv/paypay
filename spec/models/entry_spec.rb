require "rails_helper"

RSpec.describe Entry, type: :model do
  describe "#signed_value" do
    it "returns value with negative signal for outgoings" do
      expect(Entry.new(operation: "outgoing", value: "999.99").signed_value).to eq(BigDecimal("-999.99"))
    end
  end
end
