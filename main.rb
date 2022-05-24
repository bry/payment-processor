require './lib/payment_processor/payment_type/credit_card'
require './lib/payment_processor/payment_type/bank_account'
require './lib/payment_processor/transaction/credit_card_transaction'
require './lib/payment_processor/transaction/bank_transaction'
require './lib/payment_processor/payment_processor'
require './lib/payment_processor/merchant'
require 'date'

merchant_amazon = Merchant.new("Amazon")
merchant_ebay = Merchant.new("eBay")
today = Date.today

credit_card = CreditCard.new(
  card_number=4242424242424242,
  expiry=(Date.today + 365),
  cvv="123",
  billing_zip=92509,
)
cc_transaction = CreditCardTransaction.new(
  credit_card,
  today,
  6.55,
  merchant_amazon
)

bank_account = BankAccount.new(
  "01100001534214",
  routing_number="011000015"
)
bank_transaction = BankTransaction.new(
  bank_account,
  today,
  12.23,
  merchant_ebay
)

payment_processor = PaymentProcessor.new
payment_processor.accept(cc_transaction)
payment_processor.accept(bank_transaction)

payouts = payment_processor.payout(today)

# Audit
payment_processor.audit_date_and_merchant(today, merchant_ebay)
payment_processor.audit_payouts(payouts)