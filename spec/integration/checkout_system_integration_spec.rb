require 'spec_helper'
require 'checkout'
require_relative '../../lib/discount_database'

RSpec.describe 'Checkout System Integration' do
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

  describe 'complete checkout workflow' do
    let(:checkout) { Checkout.new(pricing_rules) }

    it 'handles mixed basket with multiple discount types' do
      # Apples: 2 for 1
      checkout.scan(:apple)
      checkout.scan(:apple)
      
      # Pears: 2 for 1  
      checkout.scan(:pear)
      checkout.scan(:pear)
      
      # Bananas: half price
      checkout.scan(:banana)
      
      # Pineapples: first item half price, rest full price
      checkout.scan(:pineapple)
      checkout.scan(:pineapple)
      
      # Mangoes: buy 3 get 1 free
      checkout.scan(:mango)
      checkout.scan(:mango)
      checkout.scan(:mango)
      checkout.scan(:mango)
      
      # Oranges: no discount
      checkout.scan(:orange)
      
      # Expected: 1*10 + 1*15 + 1*15 + 1*50+1*100 + 3*200 + 1*20 = 10+15+15+150+600+20 = 810
      expect(checkout.total).to eq(810)
    end

    it 'provides detailed basket summary' do
      checkout.scan(:apple)
      checkout.scan(:apple)
      checkout.scan(:banana)
      
      summary = checkout.basket_summary
      
      expect(summary[:items]).to eq([:apple, :apple, :banana])
      expect(summary[:item_counts]).to eq({ apple: 2, banana: 1 })
      expect(summary[:total_items]).to eq(3)
      expect(summary[:total_price]).to eq(25) # 1*10 + 1*15
    end

    it 'supports method chaining' do
      total = checkout
        .scan(:apple)
        .scan(:apple)
        .scan(:banana)
        .total
      
      expect(total).to eq(25)
    end
  end

  describe 'error handling' do
    let(:checkout) { Checkout.new(pricing_rules) }

    it 'raises error for unknown items' do
      expect {
        checkout.scan(:unknown_item)
      }.to raise_error(ArgumentError, /not found in pricing rules/)
    end
  end

  describe 'backward compatibility' do
    let(:checkout) { Checkout.new(pricing_rules) }

    it 'maintains existing discount behavior' do
      # Test original discount rules still work
      checkout.scan(:apple)
      checkout.scan(:apple)
      expect(checkout.total).to eq(10) # Two for one
      
      checkout = Checkout.new(pricing_rules)
      checkout.scan(:banana)
      expect(checkout.total).to eq(15) # Half price
      
      checkout = Checkout.new(pricing_rules)
      checkout.scan(:pineapple)
      expect(checkout.total).to eq(50) # Half price limited
    end
  end
end
