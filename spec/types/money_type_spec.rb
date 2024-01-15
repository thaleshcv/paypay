require "rails_helper"

RSpec.describe MoneyType do
  subject { MoneyType.new }

  describe "#cast" do
    context "with valid input" do
      it "casts from negative float-like String to positive BigDecimal" do
        expect(subject.cast("-1234567.89")).to eq(BigDecimal("1234567.89"))
      end

      it "casts from float-like String to BigDecimal" do
        expect(subject.cast("1234567.89")).to eq(BigDecimal("1234567.89"))
      end

      it "casts from currency-like String to BigDecimal" do
        expect(subject.cast("$ 1.234.567,89")).to eq(BigDecimal("1234567.89"))
      end

      it "casts from negative currency-like String to positive BigDecimal" do
        expect(subject.cast("$ -1.234.567,89")).to eq(BigDecimal("1234567.89"))
      end

      it "casts from Integer to BigDecimal" do
        expect(subject.cast(123_456_789)).to eq(BigDecimal("1234567.89"))
      end

      it "casts from Float to BigDecimal" do
        expect(subject.cast(1_234_567.89)).to eq(BigDecimal("1234567.89"))
      end
    end
  end

  describe "#serialize" do
    it "converts to Integer" do
      expect(subject.serialize(BigDecimal("1234567.89"))).to eq(123_456_789)
    end
  end
end
