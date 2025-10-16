# frozen_string_literal: true

# Two for one discount strategy - every second item is free
class TwoForOneDiscount < DiscountStrategy
  def calculate_total(quantity)
    return 0 if quantity.zero?
    
    # Calculate how many pairs we can make
    pairs = quantity / 2
    remaining_items = quantity % 2
    
    # Each pair costs for one item, plus any remaining single items
    (pairs * price) + (remaining_items * price)
  end
end
