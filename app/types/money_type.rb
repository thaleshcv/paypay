# frozen_string_literal: true

# Custom type for money/currency values.
# Any input will be casted to BigDecimal value.
# Integer inputs are handled as 'cents' values (e.g. 100 will be treated as 1.00).
# String values will have the non-digit chars stripped out and the remaining chars (digits-only)
# will be handled tha same way as Integer values.
class MoneyType < ActiveRecord::Type::Decimal
  def serialize(value)
    (value * 100).to_i
  end

  private

  REGEX_MONEY = /^\$?\s?-?(\d+(\.\d{3})*(,\d{1,2})?|\d+)$/
  REGEX_FLOAT = /^-?\d+.\d{1,2}$/

  def cast_value(value)
    casted_value =
      case value
      when String
        raise ArgumentError, "The value is not on a valid format." unless money_or_float?(value)

        (BigDecimal(value.gsub(/\D/, "")) / 100)
      when Integer
        BigDecimal(value) / 100
      else
        value
      end
    super(casted_value)
  end

  def money_or_float?(value)
    value.match(REGEX_MONEY) || value.match(REGEX_FLOAT)
  end
end
