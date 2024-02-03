FactoryBot.define do
  factory :entry do
    token { SecureRandom.hex }
    value { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    description { Faker::Lorem.sentence(word_count: 3) }
    date { Faker::Date.backward(days: 14) }
    status { "paid" }
    association :user
    association :category
  end
end
