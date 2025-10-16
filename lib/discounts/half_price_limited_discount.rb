# frozen_string_literal: true

# Half price limited discount strategy - 50% off, limited to first 3 items
class HalfPriceLimitedDiscount < DiscountStrategy
  def calculate_total(quantity)
    return 0 if quantity.zero?
    
    # First 3 items at half price, remaining at full price
    discounted_items = [quantity, 3].min
    full_price_items = [quantity - 3, 0].max
    
    (discounted_items * price * 0.5) + (full_price_items * price)
  end
end
