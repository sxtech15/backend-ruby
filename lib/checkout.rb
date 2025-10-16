require_relative 'discount_database'
require_relative 'discounts/discount_strategy_factory'

# Refactored checkout system using clean architecture principles
class Checkout
  attr_reader :pricing_rules, :discount_database

  def initialize(pricing_rules, discount_database = nil)
    @pricing_rules = pricing_rules.freeze
    @discount_database = discount_database || create_default_discount_database
  end

  def scan(item)
    validate_item_exists!(item)
    basket << item.to_sym
    self
  end

  def total
    return 0 if basket.empty?
    
    item_counts = count_items_in_basket
    calculate_total_with_discounts(item_counts)
  end

  def basket_summary
    {
      items: basket.dup,
      item_counts: count_items_in_basket,
      total_items: basket.size,
      total_price: total
    }
  end

  private

  def basket
    @basket ||= []
  end

  def count_items_in_basket
    basket.each_with_object(Hash.new(0)) { |item, counts| counts[item] += 1 }
  end

  def calculate_total_with_discounts(item_counts)
    item_counts.sum do |item, count|
      price = pricing_rules.fetch(item)
      discount_strategy = discount_database.get_discount_strategy(item, price)
      
      discount_strategy.calculate_total(count)
    end
  end

  def validate_item_exists!(item)
    unless pricing_rules.key?(item.to_sym)
      raise ArgumentError, "Item '#{item}' not found in pricing rules"
    end
  end

  def create_default_discount_database
    database = DiscountDatabase.new
    
    # Default discount rules maintaining backward compatibility
    database.add_discount_rule(:apple, 'two_for_one')
    database.add_discount_rule(:pear, 'two_for_one')
    database.add_discount_rule(:banana, 'half_price')
    database.add_discount_rule(:pineapple, 'half_price_limited')
    database.add_discount_rule(:mango, 'buy_x_get_y_free', { buy_quantity: 3, free_quantity: 1 })
    
    database
  end
end
