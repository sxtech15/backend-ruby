# frozen_string_literal: true

# No discount strategy - items are sold at full price
class NoDiscount < DiscountStrategy
  def calculate_total(quantity)
    price * quantity
  end
end
