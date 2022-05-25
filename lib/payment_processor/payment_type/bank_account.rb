require './lib/payment_processor/payment_type/payment_type'
require 'csv'

class BankAccount < PaymentType
  BANK_ROUTING_NUMBER_CSV_PATH = './config/bank_routing_numbers.csv'.freeze
  BANK_ROUTING_COLUMN_NUMBER_CSV = 0

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
    CSV.readlines(BANK_ROUTING_NUMBER_CSV_PATH).map do |line|
      line[BANK_ROUTING_COLUMN_NUMBER_CSV]
    end
  end
  VALID_ROUTING_NUMBERS ||= self.valid_routing_numbers
end
