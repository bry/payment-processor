class Transaction
  attr_accessor :date_paid_out
  attr_reader :dollar_amount, :bill_me_on_date

  def initialize
    @date_paid_out = nil
  end

  def merchant
    raise NotImplementedError.new("No merchant defined")
  end

  def processing_fee
    raise NotImplementedError.new("No processing fee defined")
  end

  def payout
    raise NotImplementedError.new("No payout defined")
  end
end
