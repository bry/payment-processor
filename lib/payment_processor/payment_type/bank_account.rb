require './lib/payment_processor/payment_type/payment_type'
require 'csv'

class BankAccount < PaymentType
  def initialize(account_number, routing_number)
    raise ArgumentError.new("Routing number is not valid") unless routing_number_valid?(routing_number)

    @account_number = encrypt(account_number)
    @routing_number = encrypt(routing_number)
  end

  private

  def routing_number_valid?(routing_number)
    VALID_ROUTING_NUMBERS.include?(routing_number)
  end

  def self.valid_routing_numbers
    CSV.readlines('./config/bank_routing_numbers.csv').map do |line|
      line[0]
    end
  end
  VALID_ROUTING_NUMBERS ||= self.valid_routing_numbers
end
