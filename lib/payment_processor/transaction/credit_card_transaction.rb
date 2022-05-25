require './lib/payment_processor/transaction/transaction'

class CreditCardTransaction < Transaction
  CREDIT_CARD_FEE_PERCENTAGE = 0.029
  CREDIT_CARD_FEE_DOLLAR_AMOUNT = 0.3

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
    @processing_fee = dollar_amount * CREDIT_CARD_FEE_PERCENTAGE + CREDIT_CARD_FEE_DOLLAR_AMOUNT
  end

  def process_payout
    @payout = @dollar_amount - @processing_fee
  end
end
