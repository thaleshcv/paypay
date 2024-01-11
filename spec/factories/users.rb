# frozen_string_literal: true

# User factory.
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "sekret" }
  end
end
