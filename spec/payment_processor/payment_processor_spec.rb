require './lib/payment_processor/payment_processor'
require './lib/payment_processor/payment_type/bank_account'
require './lib/payment_processor/payment_type/credit_card'
require './lib/payment_processor/transaction/bank_transaction'
require './lib/payment_processor/transaction/credit_card_transaction'
require './lib/payment_processor/merchant'

describe PaymentProcessor do
  let(:merchant) {
    Merchant.new("eBay")
  }
  let(:merchant_amazon) {
    Merchant.new("Amazon")
  }
  let(:bank_account) {
    BankAccount.new(
      "01100001534214",
      routing_number="011000015"
    )}
  let(:bank_transaction) {
    BankTransaction.new(
      bank_account,
      Date.today,
      12.23,
      Merchant.new("eBay")
    )
  }
  let(:credit_card) {
    CreditCard.new(
      card_number=4242424242424242,
      expiry=(Date.today + 365),
      cvv="123",
      billing_zip=92509,
    )
  }
  let(:cc_transaction) {
    CreditCardTransaction.new(
      credit_card,
      Date.today,
      6.55,
      merchant_amazon
    )
  }

  describe '#accept(payment)' do
    context 'when accepting a bank transaction' do
      it "adds one bank transaction to transactions" do
        payment_processor = PaymentProcessor.new
        payment_processor.accept(bank_transaction)
        expect(payment_processor.transactions.count).to eq(1)
      end
    end
  end

  describe '#payout(date)' do
    context 'when accepted a bank transaction and payout on a date' do
      it "adds one payout to payouts" do
        payment_processor = PaymentProcessor.new
        payment_processor.accept(bank_transaction)
        payment_processor.payout(Date.today)
        expect(payment_processor.payouts.count).to eq(1)
      end
    end

    context 'when accepted a merchant bank transaction and a merchant_amazon credit card transaction' do
      it "adds two payouts to different merchants" do
        payment_processor = PaymentProcessor.new
        payment_processor.accept(bank_transaction)
        payment_processor.accept(cc_transaction)
        payment_processor.payout(Date.today)
        expect(payment_processor.payouts.count).to eq(2)
        expect(payment_processor.payouts.first.transactions.first.merchant.name).to eq("eBay")
        expect(payment_processor.payouts.last.transactions.first.merchant.name).to eq("Amazon")
      end
    end
  end

  describe '#audit_date_and_merchant(date, merchant)' do
    context 'when date and merchant match a transaction' do
      it 'pretty prints the selected transactions' do
        payment_processor = PaymentProcessor.new
        payment_processor.accept(bank_transaction)
        payment_processor.payout(Date.today)
        selections = payment_processor.audit_date_and_merchant(Date.today, merchant)
        expect(selections.first.merchant.name).to eq("eBay")
        expect(selections.first.bill_me_on_date).to eq(Date.today)
      end
    end
  end

  describe '#audit_payouts(payouts)' do
    context 'when passing in payouts' do
      it 'pretty prints the payouts' do
        payment_processor = PaymentProcessor.new
        payment_processor.accept(bank_transaction)
        payouts = payment_processor.payout(Date.today)
        printed_payouts = payment_processor.audit_payouts(payouts)
        expect(printed_payouts.count).to eq(1)
      end
    end
  end
end