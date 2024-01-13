FactoryBot.define do
  factory :entry do
    category { nil }
    operation { 1 }
    value { 1 }
    title { "MyString" }
    comment { "MyText" }
    date { "2024-01-13" }
    balance { 1 }
  end
end
