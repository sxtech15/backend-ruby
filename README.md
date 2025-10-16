# Checkout System - Refactored Architecture

## Overview

This project demonstrates a comprehensive refactoring from a monolithic checkout system to a clean, maintainable architecture using advanced OOP principles and design patterns.

## Architecture

### Design Patterns Applied

1. **Strategy Pattern**: Encapsulates different discount calculation algorithms
2. **Factory Pattern**: Centralizes object creation logic for discount strategies  
3. **Repository Pattern**: Manages discount rule storage and retrieval
4. **Value Object Pattern**: Represents monetary values with immutable objects

### Key Components

- `Checkout`: Main orchestrator class
- `DiscountDatabase`: Repository for discount rules
- `DiscountStrategyFactory`: Factory for creating discount strategies
- `DiscountStrategy`: Base class for all discount strategies
- `Money`: Value object for monetary calculations

### Discount Strategies

- `NoDiscount`: No discount applied
- `TwoForOneDiscount`: Every second item free
- `HalfPriceDiscount`: 50% off all items
- `HalfPriceLimitedDiscount`: 50% off, limited quantity
- `BuyXGetYFreeDiscount`: Buy X items, get Y free

## Usage

```ruby
# Basic usage with default discounts
pricing_rules = { apple: 10, mango: 200 }
checkout = Checkout.new(pricing_rules)

checkout.scan(:apple).scan(:apple)  # Two for one
checkout.scan(:mango).scan(:mango).scan(:mango).scan(:mango)  # Buy 3 get 1 free

puts checkout.total  # Calculates total with discounts

# Custom discount configuration
custom_database = DiscountDatabase.new
custom_database.add_discount_rule(:orange, 'two_for_one')

checkout = Checkout.new(pricing_rules, custom_database)
```

## Running Tests

```bash
bundle exec rspec
```

## Requirements Fulfilled

✅ Buy 3 get 1 free on Mangos  
✅ Dynamic discount specification from database  
✅ Refactored code to apply discounts from database  
✅ Maintainable architecture with SOLID principles  
✅ Comprehensive test coverage
