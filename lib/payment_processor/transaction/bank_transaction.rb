require './lib/payment_processor/transaction/transaction'

class BankTransaction < Transaction
  BANK_FEE_PERCENTAGE = 0.01
  BANK_FEE_DOLLAR_AMOUNT = 1

  def initialize(payment_type, bill_me_on_date, dollar_amount, merchant)
    @payment_type = payment_type
    @bill_me_on_date = bill_me_on_date
    @dollar_amount = dollar_amount
    @merchant = merchant
    process_fee
    process_payout
  end

  def merchant
    @merchant
  end

  def processing_fee
    @processing_fee || 0
  end

  def payout
    @payout || 0
  end

  private

  def process_fee
    @processing_fee = dollar_amount * BANK_FEE_PERCENTAGE + BANK_FEE_DOLLAR_AMOUNT
  end

  def process_payout
    @payout = @dollar_amount - @processing_fee
  end
end
