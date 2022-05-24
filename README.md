# Payment Processor Simulator

A payment processor simulator

## Features
- Card and bank details RSA encrypted before stored
- Exception on credit cards starting with 1111 or 8888
- Exception on any expiry date in the past
- Bank routing numbers are validated
- Payouts made net of fees assessed at 2.9% + 30c per transaction or 1% + $1 for a bank transfer
- Transactions marked paid via date_paid_out after payout processing

## Usage
main.rb is the program entry point
```ruby 
ruby main.rb
```

## Usage Examples

### Merchants
Create a Merchant
```ruby
merchant_amazon = Merchant.new("Amazon")
```

### Credit Card Transactions
Create a Credit Card
```ruby
credit_card = CreditCard.new(
  card_number=4242424242424242,
  expiry=(Date.today + 365),
  cvv="123",
  billing_zip=92509,
)
```

Create a Credit Card Transaction
```ruby
cc_transaction = CreditCardTransaction.new(
  credit_card,
  today,
  6.55,
  merchant_amazon
)
```

### Bank Account Transactions
Create a Bank Account
```ruby
bank_account = BankAccount.new(
  "01100001534214",
  routing_number="011000015"
)
```

Create a Bank Account Transaction
```ruby
bank_transaction = BankTransaction.new(
  bank_account,
  today,
  12.23,
  merchant_ebay
)
```

### Payment Processor
Create a Payment Processor

```ruby
payment_processor = PaymentProcessor.new
```

Accept Transactions

```ruby
payment_processor.accept(cc_transaction)
payment_processor.accept(bank_transaction)
```

Create Payouts given a Date
```ruby
payouts = payment_processor.payout(today)
```

### Audit
Pretty Print Transactions and Payouts
```ruby
payment_processor.audit_date_and_merchant(today, merchant_ebay)
payment_processor.audit_payouts(payouts)
```

### RSA Encryption
Sample Ruby RSA Encryption and Decryption scripts

```ruby
require 'openssl'
require 'base64'

# 1. Generate a private.pem key file
# > openssl genrsa -des3 -out private.pem 2048
# config/rsa/private.pem
#
# 2. password: paymentprocessor
# 
# 3. Generate public.pem keyfile
# > openssl rsa -in private.pem -out public.pem -outform PEM -pubout
# config/rsa/public.pem

# Encrypt a string using public.pem keyfile
public_key_file = "./config/rsa/public.pem"
string = "Hello World!"
public_key = OpenSSL::PKey::RSA.new(File.read(public_key_file))
encrypted_string = Base64.encode64(public_key.public_encrypt(string))
p encrypted_string

# Decrypt an encrypted string using private.pem keyfile
private_key_file = './config/rsa/private.pem';
password = 'paymentprocessor'
private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file),password)
string = private_key.private_decrypt(Base64.decode64(encrypted_string))

print string, "\n"
```

## Tests
Sample payment_processor_spec.rb RSpecs

### Run Tests

```console
> bundle exec rspec
```

## Improvements
- RSpec standard output suppression
- Audit methods output cleanup
- More specs, boundary case specs
- require cleanup
- Web or desktop app w/ database