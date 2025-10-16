require 'spec_helper'
require_relative '../lib/discount_database'

RSpec.describe DiscountDatabase do
  let(:database) { DiscountDatabase.new }

  describe '#add_discount_rule' do
    it 'adds a simple discount rule' do
      database.add_discount_rule(:apple, 'two_for_one')
      expect(database.has_discount?(:apple)).to be true
    end

    it 'adds a discount rule with parameters' do
      database.add_discount_rule(:mango, 'buy_x_get_y_free', { buy_quantity: 3, free_quantity: 1 })
      expect(database.has_discount?(:mango)).to be true
    end
  end

  describe '#get_discount_strategy' do
    before do
      database.add_discount_rule(:apple, 'two_for_one')
    end

    it 'returns correct strategy for item with discount' do
      strategy = database.get_discount_strategy(:apple, 100)
      expect(strategy.class.name).to eq('TwoForOneDiscount')
    end

    it 'returns no discount strategy for item without discount' do
      strategy = database.get_discount_strategy(:orange, 100)
      expect(strategy.class.name).to eq('NoDiscount')
    end
  end

  describe '#all_rules' do
    it 'returns all discount rules' do
      database.add_discount_rule(:apple, 'two_for_one')
      database.add_discount_rule(:banana, 'half_price')
      
      rules = database.all_rules
      expect(rules.keys).to include(:apple, :banana)
    end
  end
end
