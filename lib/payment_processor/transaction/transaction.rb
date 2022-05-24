class Transaction
  attr_accessor :date_paid_out, :bill_me_on_date, :dollar_amount

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
