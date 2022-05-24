require './lib/payment_processor/payment_type/payment_type'

class CreditCard < PaymentType
  def initialize(card_number, expiry, cvv, billing_zip)
    raise StandardError.new("Card starts with 8888 or 1111") if /^(8888|1111)/.match(card_number.to_s)
    raise StandardError.new("Expiry date not in future") if expiry <= Date.today

    @card_number = encrypt(card_number)
    @expiry = encrypt(expiry)
    @cvv = encrypt(cvv)
    @billing_zip = encrypt(billing_zip)
  end
end
