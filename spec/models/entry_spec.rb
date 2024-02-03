require "rails_helper"

RSpec.describe Entry, type: :model do
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
end
