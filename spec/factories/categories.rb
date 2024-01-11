# frozen_string_literal: true

# Category factory.
FactoryBot.define do
  factory :category do
    name { Faker::Lorem.word }
  end
end
