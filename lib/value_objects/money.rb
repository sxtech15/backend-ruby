# frozen_string_literal: true

require 'bigdecimal'

# Value object representing monetary amounts
class Money
  include Comparable

  def initialize(amount, currency = 'USD')
    @amount = BigDecimal(amount.to_s)
    @currency = currency.to_s.upcase.freeze
  end

  attr_reader :amount, :currency

  # Adds another Money instance
  def +(other)
    raise ArgumentError, "Cannot operate on different currencies" unless currency == other.currency
    Money.new(amount + other.amount, currency)
  end

  # Multiplies by a numeric factor
  def *(factor)
    Money.new(amount * factor, currency)
  end

  # Compares with another Money instance
  def <=>(other)
    return nil unless other.is_a?(Money)
    return nil unless currency == other.currency
    
    amount <=> other.amount
  end

  # Checks equality with another object
  def ==(other)
    return false unless other.is_a?(Money)
    
    currency == other.currency && amount == other.amount
  end

  # Returns formatted string representation
  def to_s
    "#{currency} #{format('%.2f', amount)}"
  end
end
