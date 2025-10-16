require 'spec_helper'
require 'checkout'
require_relative '../lib/discount_database'

RSpec.describe 'Checkout with Dynamic Discounts' do
  let(:pricing_rules) {
    {
      apple: 10,
      orange: 20,
      pear: 15,
      banana: 30,
      pineapple: 100,
      mango: 200
    }
  }

  describe 'with custom discount database' do
    let(:custom_database) { DiscountDatabase.new }
    let(:checkout) { Checkout.new(pricing_rules, custom_database) }

    it 'applies custom discount rules' do
      # Add custom discount: buy 2 get 1 free for oranges
      custom_database.add_discount_rule(:orange, 'buy_x_get_y_free', { buy_quantity: 2, free_quantity: 1 })
      
      # Buy 3 oranges: should pay for 2
      checkout.scan(:orange)
      checkout.scan(:orange)
      checkout.scan(:orange)
      
      expect(checkout.total).to eq(40) # 2 * 20
    end

    it 'applies no discount when no rule exists' do
      # Orange has no discount rule
      checkout.scan(:orange)
      checkout.scan(:orange)
      
      expect(checkout.total).to eq(40) # 2 * 20 (full price)
    end

    it 'allows runtime discount rule changes' do
      # Initially no discount for apple
      checkout.scan(:apple)
      checkout.scan(:apple)
      expect(checkout.total).to eq(20) # 2 * 10 (full price)
      
      # Add discount rule
      custom_database.add_discount_rule(:apple, 'two_for_one')
      
      # Clear basket and rescan
      checkout = Checkout.new(pricing_rules, custom_database)
      checkout.scan(:apple)
      checkout.scan(:apple)
      expect(checkout.total).to eq(10) # 1 * 10 (two for one)
    end
  end

  describe 'mango buy 3 get 1 free requirement' do
    let(:checkout) { Checkout.new(pricing_rules) }

    it 'applies buy 3 get 1 free discount to mangoes' do
      # Buy 4 mangoes: should pay for 3
      4.times { checkout.scan(:mango) }
      
      expect(checkout.total).to eq(600) # 3 * 200
    end

    it 'handles multiple sets of mangoes' do
      # Buy 8 mangoes: should pay for 6
      8.times { checkout.scan(:mango) }
      
      expect(checkout.total).to eq(1200) # 6 * 200
    end

    it 'handles partial sets of mangoes' do
      # Buy 5 mangoes: should pay for 4
      5.times { checkout.scan(:mango) }
      
      expect(checkout.total).to eq(800) # 4 * 200
    end
  end
end
