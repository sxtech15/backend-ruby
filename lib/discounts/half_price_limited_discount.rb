# frozen_string_literal: true

# Half price limited discount strategy - 50% off, limited to first 3 items
class HalfPriceLimitedDiscount < DiscountStrategy
  def calculate_total(quantity)
    return 0 if quantity.zero?
    
    # First item at half price, remaining at full price (original logic)
    first_item_discount = price * 0.5
    remaining_items = [quantity - 1, 0].max
    
    first_item_discount + (remaining_items * price)
  end
end
