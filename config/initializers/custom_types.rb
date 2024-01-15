# frozen_string_literal: true

Dir[Rails.root.join("app", "types", "*.rb")].each { |f| require f }

ActiveRecord::Type.register(:money, MoneyType)
