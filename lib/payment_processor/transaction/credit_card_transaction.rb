require './lib/payment_processor/transaction/transaction'

class CreditCardTransaction < Transaction
  attr_reader :bill_me_on_date

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
    @processing_fee
  end

  def payout
    @payout
  end

  private

  def process_fee
    @processing_fee = dollar_amount * 0.029 + 0.3
  end

  def process_payout
    @payout = @dollar_amount - @processing_fee
  end
end
