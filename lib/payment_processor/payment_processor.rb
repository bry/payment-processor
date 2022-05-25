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
    merchant_payouts = {}
    selected_transactions.each do |txn|
      transaction_merchant_name = txn.merchant.name

      if merchant_payouts.keys.include?(transaction_merchant_name)
        merchant_payouts[transaction_merchant_name].add(txn)
      else
        merchant_payouts[transaction_merchant_name] = Payout.new(txn)
      end

      txn.date_paid_out = @date
    end
    merchant_payouts
  end

  # Add to payouts
  def date_payouts
    this_payout = []
    merchant_payouts.each_value do |payout|
      @payouts << payout
      this_payout << payout
    end
    this_payout
  end
end
