class TaxGoodService < Transaction
  def calculate
    # If the buyer is in Spain or is an individual consumer in an EU country
    if country.alpha2 == 'ES' || (country.in_eu_vat? && @buyer_type == 'individual')
      tax_rate = country.vat_rates['standard']
      tax_amount, subtotal = tax_calculation(tax_rate)
      { status: 'taxable', country: country.alpha2, tax_rate:, tax_amount:, subtotal:, total_amount: (tax_amount + subtotal).round(2) }
    else # No tax will be applied
      status = country.in_eu_vat? ? 'reverse_charge' : 'export'
      { status: status, country: country.alpha2, tax_rate: 0, tax_amount: 0, subtotal: amount, total_amount: amount }
    end
  end
end
