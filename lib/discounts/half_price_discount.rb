# frozen_string_literal: true

# Half price discount strategy - 50% off all items
class HalfPriceDiscount < DiscountStrategy
  def calculate_total(quantity)
    price * quantity * 0.5
  end
end
