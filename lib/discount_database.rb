# frozen_string_literal: true

require_relative 'discounts/discount_strategy_factory'

# Repository for managing discount rules
class DiscountDatabase
  def initialize
    @discount_rules = {}
  end

  # Adds a discount rule for a specific item
  def add_discount_rule(item, strategy_type, params = {})
    @discount_rules[item.to_sym] = {
      strategy_type: strategy_type,
      params: params
    }.freeze
  end

  # Gets the discount strategy for a specific item and price
  def get_discount_strategy(item, price)
    rule = @discount_rules[item.to_sym]
    return DiscountStrategyFactory.create_strategy('no_discount', item, price) unless rule

    DiscountStrategyFactory.create_strategy(
      rule[:strategy_type], 
      item, 
      price, 
      rule[:params]
    )
  end

  # Checks if an item has a discount rule
  def has_discount?(item)
    @discount_rules.key?(item.to_sym)
  end

  # Gets all discount rules
  def all_rules
    @discount_rules.dup
  end
end
