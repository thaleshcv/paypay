# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

return unless Rails.env.development?

puts "---------------- RUNNING SEED ----------------"

user = User.create!(email: "user@example.org", password: "sekret")

10.times do
  Category.create!(name: Faker::Lorem.word.capitalize)
end

categories = Category.all

((Date.today - 90.days)..Date.today).each do |dt|
  15.times do
    Entry.create!(
      user: user,
      category: categories.sample,
      operation: %w[income outgoing].sample,
      date: dt,
      title: Faker::Lorem.word.capitalize,
      value: Faker::Number.decimal(l_digits: 3, r_digits: 2)
    )
  end
end
