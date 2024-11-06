class Transaction
  attr_accessor :amount, :country

  def initialize(buyer_type, buyer_country, amount, tax_behavior = 'exclusive')
    @buyer_type = buyer_type
    @amount = amount.to_f
    @country = ISO3166::Country.new(buyer_country)
    @tax_behavior = tax_behavior
  end

  def tax_calculation(tax_rate)
    if @tax_behavior == 'inclusive'
      tax_amount = (amount * tax_rate / (100 + tax_rate)).round(2)
      subtotal = (amount - tax_amount).round(2)
    else
      tax_amount = (amount * tax_rate / 100).round(2)
      subtotal = amount
    end
    [tax_amount, subtotal]
  end
end
