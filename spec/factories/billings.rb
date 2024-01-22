FactoryBot.define do
  factory :billing do
    description { "MyString" }
    due_date { 1 }
    cycles { 1 }
    last_entry { nil }
  end
end
