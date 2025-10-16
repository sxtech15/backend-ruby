# frozen_string_literal: true

# Base class for all discount strategies
# Follows the Strategy pattern to encapsulate different discount algorithms
class DiscountStrategy
  def initialize(item, price)
    @item = item
    @price = price
  end

  # Calculate the total price for a given quantity of items
  # This method should be implemented by subclasses
  def calculate_total(quantity)
    raise NotImplementedError, "Subclasses must implement calculate_total method"
  end

  public

  attr_reader :item, :price
end
