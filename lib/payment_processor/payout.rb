class Payout
  attr_reader :transactions, :lump_sum_payout

  def initialize(transaction)
    @transactions = [transaction]
    set_lump_sum_payout
    @merchant = transaction.merchant
  end

  def add(transaction)
    @transactions << transaction
    set_lump_sum_payout
  end

  private

  def set_lump_sum_payout
    @lump_sum_payout = @transactions.sum(0) {|transaction| transaction.payout}
  end
end
