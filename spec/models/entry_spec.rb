require "rails_helper"

RSpec.describe Entry, type: :model do
  it "cannot change operation on a persisted entry" do
    current_user = FactoryBot.create(:user)
    category = FactoryBot.create(:category)
    entry = Entry.create!(
      title: "This is a test",
      operation: "income",
      user: current_user,
      category: category,
      date: Date.today,
      value: 999.99
    )

    entry.update(operation: "outgoing")

    expect(entry.valid?).to be_falsey
    expect(entry.errors.where(:operation, :invalid)).not_to be_empty
  end

  it "cannot use a discarded category" do
    current_user = FactoryBot.create(:user)
    category = FactoryBot.create(:category, user: current_user, discarded_at: Time.zone.now)
    entry = Entry.new(user: current_user, category: category)

    expect(entry.valid?).to be_falsey
    expect(entry.errors.where(:category, :invalid)).not_to be_empty
  end

  it "cannot use a category from other user" do
    current_user = FactoryBot.create(:user)
    category = FactoryBot.create(:category, user: FactoryBot.create(:user))
    entry = Entry.new(user: current_user, category: category)

    expect(entry.valid?).to be_falsey
    expect(entry.errors.where(:category, :invalid)).not_to be_empty
  end

  describe "#signed_value" do
    it "returns value with negative signal for outgoings" do
      expect(Entry.new(operation: "outgoing", value: "999.99").signed_value).to eq(BigDecimal("-999.99"))
    end
  end
end
