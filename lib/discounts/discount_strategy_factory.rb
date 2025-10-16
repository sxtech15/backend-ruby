# frozen_string_literal: true

require_relative 'discount_strategy'
require_relative 'no_discount'
require_relative 'two_for_one_discount'
require_relative 'half_price_discount'
require_relative 'half_price_limited_discount'
require_relative 'buy_x_get_y_free_discount'

# Factory for creating discount strategy instances
class DiscountStrategyFactory
  # Registry of available discount strategies
  STRATEGY_REGISTRY = {
    'no_discount' => NoDiscount,
    'two_for_one' => TwoForOneDiscount,
    'half_price' => HalfPriceDiscount,
    'half_price_limited' => HalfPriceLimitedDiscount,
    'buy_x_get_y_free' => BuyXGetYFreeDiscount
  }

  class << self
    # Creates a discount strategy instance based on type and parameters
    def create_strategy(strategy_type, item, price, params = {})
      strategy_class = STRATEGY_REGISTRY[strategy_type]
      
      unless strategy_class
        raise ArgumentError, "Unknown discount strategy: #{strategy_type}"
      end

      # Create strategy instance with appropriate parameters
      if strategy_class == BuyXGetYFreeDiscount
        # BuyXGetYFreeDiscount requires specific parameters
        strategy_class.new(item, price, params[:buy_quantity], params[:free_quantity])
      else
        # Most strategies only need item and price
        strategy_class.new(item, price)
      end
    end

    # Returns list of available strategy types
    def available_strategies
      STRATEGY_REGISTRY.keys.freeze
    end
  end
end
