require 'date'
require './lib/payment_processor/payout'

class PaymentProcessor
  attr_reader :transactions, :payouts

  def initialize
    @transactions = []
    @payouts = []
  end

  def accept(payment)
    @transactions << payment
  end

  def payout(date)
    @date = date

    date_payouts
  end

  def audit_date_and_merchant(date, merchant)
    selections = @transactions.select do |transaction|
      (transaction.bill_me_on_date == date) && (transaction.merchant.name == merchant.name)
    end
    pp selections
  end

  def audit_payouts(payouts)
    pp payouts
  end

  private

  # Find transactions by date <= date && not paid out (date_paid_out = nil)
  def selected_transactions
    @transactions.select do |transaction|
      transaction.date_paid_out.nil? && (transaction.bill_me_on_date <= @date)
    end
  end

  # Create a payout per merchant from selected transactions
  def merchant_payouts
    _merchant_payouts = {}
    selected_transactions.each do |txn|
      if _merchant_payouts.keys.include?(txn.merchant.name)
        _merchant_payouts[txn.merchant.name].add(txn)
      else
        _merchant_payouts[txn.merchant.name] = Payout.new(txn)
      end

      txn.date_paid_out = @date
    end
    _merchant_payouts
  end

  # Add to payouts
  def date_payouts
    _payouts = []
    merchant_payouts.each_value do |payout|
      @payouts << payout
      _payouts << payout
    end
    _payouts
  end
end
