require 'spec_helper'
require_relative '../lib/discounts/no_discount'
require_relative '../lib/discounts/two_for_one_discount'
require_relative '../lib/discounts/half_price_discount'
require_relative '../lib/discounts/half_price_limited_discount'
require_relative '../lib/discounts/buy_x_get_y_free_discount'

RSpec.describe 'Discount Strategies' do
  let(:price) { 100 }

  describe NoDiscount do
    subject(:strategy) { NoDiscount.new(:item, price) }

    it 'charges full price for all items' do
      expect(strategy.calculate_total(1)).to eq(100)
      expect(strategy.calculate_total(3)).to eq(300)
    end

    it 'returns zero for zero quantity' do
      expect(strategy.calculate_total(0)).to eq(0)
    end
  end

  describe TwoForOneDiscount do
    subject(:strategy) { TwoForOneDiscount.new(:item, price) }

    it 'charges for one item when buying two' do
      expect(strategy.calculate_total(2)).to eq(100)
    end

    it 'charges for two items when buying three' do
      expect(strategy.calculate_total(3)).to eq(200)
    end

    it 'charges for one item when buying one' do
      expect(strategy.calculate_total(1)).to eq(100)
    end
  end

  describe HalfPriceDiscount do
    subject(:strategy) { HalfPriceDiscount.new(:item, price) }

    it 'charges half price for all items' do
      expect(strategy.calculate_total(1)).to eq(50)
      expect(strategy.calculate_total(3)).to eq(150)
    end
  end

  describe HalfPriceLimitedDiscount do
    subject(:strategy) { HalfPriceLimitedDiscount.new(:item, price) }

    it 'charges half price for first 3 items' do
      expect(strategy.calculate_total(3)).to eq(150)
    end

    it 'charges half price for first 3, full price for rest' do
      expect(strategy.calculate_total(5)).to eq(350) # 3*50 + 2*100
    end
  end

  describe BuyXGetYFreeDiscount do
    subject(:strategy) { BuyXGetYFreeDiscount.new(:item, price, 3, 1) }

    it 'charges for 3 items when buying 4' do
      expect(strategy.calculate_total(4)).to eq(300)
    end

    it 'charges for 6 items when buying 8' do
      expect(strategy.calculate_total(8)).to eq(600)
    end

    it 'charges full price when not reaching threshold' do
      expect(strategy.calculate_total(2)).to eq(200)
    end
  end
end
