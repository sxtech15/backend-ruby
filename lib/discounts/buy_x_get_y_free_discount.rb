# frozen_string_literal: true

# Buy X get Y free discount strategy
# For example: Buy 3 get 1 free
class BuyXGetYFreeDiscount < DiscountStrategy
  def initialize(item, price, buy_quantity, free_quantity)
    super(item, price)
    @buy_quantity = buy_quantity
    @free_quantity = free_quantity
  end

  def calculate_total(quantity)
    return 0 if quantity.zero?
    
    # Calculate how many complete sets we can make
    complete_sets = quantity / (buy_quantity + free_quantity)
    remaining_items = quantity % (buy_quantity + free_quantity)
    
    # Each complete set costs for buy_quantity items
    total_cost = complete_sets * buy_quantity * price
    
    # Remaining items are charged at full price
    total_cost + (remaining_items * price)
  end

  private

  attr_reader :buy_quantity, :free_quantity
end
