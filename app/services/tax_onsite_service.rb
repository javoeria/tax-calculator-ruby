class TaxOnsiteService < Transaction
  def initialize(buyer_type, buyer_country, amount, tax_behavior = 'exclusive')
    super
    @country = ISO3166::Country.new('ES')
  end

  def calculate
    # Spanish VAT will be applied
    tax_rate = country.vat_rates['standard']
    tax_amount, subtotal = tax_calculation(tax_rate)
    { status: 'taxable', country: country.alpha2, tax_rate:, tax_amount:, subtotal:, total_amount: (tax_amount + subtotal).round(2) }
  end
end
