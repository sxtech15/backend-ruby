require 'spec_helper'
require_relative '../lib/discounts/discount_strategy_factory'

RSpec.describe DiscountStrategyFactory do
  describe '.create_strategy' do
    it 'creates NoDiscount strategy' do
      strategy = DiscountStrategyFactory.create_strategy('no_discount', :item, 100)
      expect(strategy.class.name).to eq('NoDiscount')
    end

    it 'creates TwoForOneDiscount strategy' do
      strategy = DiscountStrategyFactory.create_strategy('two_for_one', :item, 100)
      expect(strategy.class.name).to eq('TwoForOneDiscount')
    end

    it 'creates HalfPriceDiscount strategy' do
      strategy = DiscountStrategyFactory.create_strategy('half_price', :item, 100)
      expect(strategy.class.name).to eq('HalfPriceDiscount')
    end

    it 'creates BuyXGetYFreeDiscount strategy with parameters' do
      strategy = DiscountStrategyFactory.create_strategy(
        'buy_x_get_y_free', :item, 100, { buy_quantity: 3, free_quantity: 1 }
      )
      expect(strategy.class.name).to eq('BuyXGetYFreeDiscount')
    end

    it 'raises error for unknown strategy' do
      expect {
        DiscountStrategyFactory.create_strategy('unknown', :item, 100)
      }.to raise_error(ArgumentError, /Unknown discount strategy/)
    end
  end

  describe '.available_strategies' do
    it 'returns list of available strategies' do
      strategies = DiscountStrategyFactory.available_strategies
      expect(strategies).to include('no_discount', 'two_for_one', 'half_price')
    end
  end
end
