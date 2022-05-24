class Transaction
  attr_accessor :date_paid_out, :bill_me_on_date, :dollar_amount

  def initialize()
    super
    @date_paid_out = nil
  end

  def merchant
    raise StandardError.new("No merchant defined")
  end
end
