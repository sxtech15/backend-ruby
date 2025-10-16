#!/usr/bin/env ruby

require_relative 'lib/checkout'
require_relative 'lib/discount_database'

# Demo script showing the refactored checkout system
puts "=== Checkout System Demo ===\n\n"

# Define pricing rules
pricing_rules = {
  apple: 10,
  orange: 20,
  pear: 15,
  banana: 30,
  pineapple: 100,
  mango: 200
}

puts "Pricing Rules:"
pricing_rules.each { |item, price| puts "  #{item}: $#{price}" }
puts "\n"

# Demo 1: Default discount behavior
puts "Demo 1: Default Discounts"
checkout = Checkout.new(pricing_rules)

puts "Scanning: 2 apples, 1 banana, 1 pineapple"
checkout.scan(:apple).scan(:apple)
checkout.scan(:banana)
checkout.scan(:pineapple)

puts "Total: $#{checkout.total}"
puts "Basket Summary: #{checkout.basket_summary}"
puts "\n"

# Demo 2: Mango buy 3 get 1 free
puts "Demo 2: Mango Buy 3 Get 1 Free"
checkout2 = Checkout.new(pricing_rules)

puts "Scanning: 4 mangoes"
4.times { checkout2.scan(:mango) }

puts "Total: $#{checkout2.total} (should be $600 for 3 mangoes)"
puts "\n"

# Demo 3: Custom discount database
puts "Demo 3: Custom Discount Rules"
custom_database = DiscountDatabase.new
custom_database.add_discount_rule(:orange, 'buy_x_get_y_free', { buy_quantity: 2, free_quantity: 1 })
custom_database.add_discount_rule(:pear, 'half_price')

checkout3 = Checkout.new(pricing_rules, custom_database)

puts "Scanning: 3 oranges, 2 pears"
3.times { checkout3.scan(:orange) }
2.times { checkout3.scan(:pear) }

puts "Total: $#{checkout3.total}"
puts "  Oranges: Buy 2 get 1 free = $#{2 * 20}"
puts "  Pears: Half price = $#{2 * 15 * 0.5}"
puts "  Total expected: $#{2 * 20 + 2 * 15 * 0.5}"
puts "\n"

# Demo 4: Mixed basket
puts "Demo 4: Mixed Basket with All Discount Types"
checkout4 = Checkout.new(pricing_rules)

puts "Scanning: 2 apples, 2 pears, 1 banana, 1 pineapple, 4 mangoes, 1 orange"
checkout4.scan(:apple).scan(:apple)
checkout4.scan(:pear).scan(:pear)
checkout4.scan(:banana)
checkout4.scan(:pineapple)
4.times { checkout4.scan(:mango) }
checkout4.scan(:orange)

puts "Total: $#{checkout4.total}"
puts "Basket Summary:"
summary = checkout4.basket_summary
puts "  Items: #{summary[:item_counts]}"
puts "  Total Items: #{summary[:total_items]}"
puts "\n"

puts "=== Demo Complete ==="
