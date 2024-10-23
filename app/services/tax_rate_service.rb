class TaxRateService
  attr_accessor :amount

  def initialize(transaction_type, buyer_type, buyer_country, amount)
    @transaction_type = transaction_type
    @buyer_type = buyer_type
    @buyer_country = transaction_type == 'service_onsite' ? 'ES' : buyer_country
    @amount = amount.to_f
  end

  def calculate
    c = ISO3166::Country.new(@buyer_country)
    # If the buyer is in Spain or is an individual consumer in an EU country
    if c.alpha2 == 'ES' || (c.in_eu_vat? && @buyer_type == 'individual')
      tax_rate = c.vat_rates['standard']
      tax_amount = (amount * tax_rate / 100).round(2)
      { status: 'taxable', country: c.alpha2, tax_rate: tax_rate, tax_amount: tax_amount, subtotal: amount, total_amount: tax_amount + amount }
    else # No tax will be applied
      { status: no_tax_status(c.in_eu_vat?), country: c.alpha2, tax_rate: 0, tax_amount: 0, subtotal: amount, total_amount: amount }
    end
  end

  private

  def no_tax_status(eu_member)
    if eu_member
      'reverse_charge'
    elsif @transaction_type == 'good'
      'export'
    else
      'non_taxable'
    end
  end
end
