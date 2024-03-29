# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "---------------- RUNNING SEED ----------------"

[
  # "Alimentação",
  "Supermercados",
  "Bares/Restaurantes",
  # Moradia,
  "Aluguel",
  "Financiamento Imobiliário",
  "Condomínio",
  "Água/Luz/Gás/Telefone/Internet",
  # "Transporte",
  "Combustível",
  "Táxi/Uber/Coletivos",
  "Oficina Mecânica",
  "Estacionamento/Pedágio",
  # "Saúde",
  "Planos de saúde",
  "Farmácia",
  "Consultas/Exames",
  "Clínicas/Terapias",
  # "Educação",
  "Mensalidade escolar",
  "Lazer/Viagens",
  "Vestuário",
  "Dívidas",
  "Impostos/Taxas",
  "Doações/Caridade"
].sort.each { |name| Category.create!(name: name) }

# SEED FOR DEVELOPMENT ONLY

return unless Rails.env.development?

user = User.create!(email: "user@example.org", password: "sekret")
categories = Category.all

days = (1..25).to_a
months = [[10, 2023], [11, 2023], [12, 2023], [1, 2024]]

months.each do |(m, y)|
  15.times do
    Entry.create!(
      user: user,
      category: categories.sample,
      date: Date.new(y, m, days.sample),
      description: Faker::Lorem.sentence,
      value: Faker::Number.decimal(l_digits: 3, r_digits: 2),
      status: %w[pending paid].sample
    )
  end
end
