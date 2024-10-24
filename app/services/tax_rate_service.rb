class TaxRateService
  attr_accessor :amount

  def initialize(transaction_type, buyer_type, buyer_country, amount, tax_behavior = 'exclusive')
    @transaction_type = transaction_type
    @buyer_type = buyer_type
    @buyer_country = transaction_type == 'service_onsite' ? 'ES' : buyer_country
    @amount = amount.to_f
    @tax_behavior = tax_behavior
  end

  def calculate
    c = ISO3166::Country.new(@buyer_country)
    # If the buyer is in Spain or is an individual consumer in an EU country
    if c.alpha2 == 'ES' || (c.in_eu_vat? && @buyer_type == 'individual')
      tax_rate = c.vat_rates['standard']
      if @tax_behavior == 'inclusive'
        tax_amount = (amount * tax_rate / (100 + tax_rate)).round(2)
        subtotal = (amount - tax_amount).round(2)
      else
        tax_amount = (amount * tax_rate / 100).round(2)
        subtotal = amount
      end
      { status: 'taxable', country: c.alpha2, tax_rate:, tax_amount:, subtotal:, total_amount: (tax_amount + subtotal).round(2) }
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
