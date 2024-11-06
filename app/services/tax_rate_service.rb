class TaxRateService
  def initialize(transaction_type, buyer_type, buyer_country, amount, tax_behavior = 'exclusive')
    @transaction_type = transaction_type
    @buyer_type = buyer_type
    @buyer_country = buyer_country
    @amount = amount
    @tax_behavior = tax_behavior
  end

  def calculate
    case @transaction_type
    when 'good'
      TaxGoodService.new(@buyer_type, @buyer_country, @amount, @tax_behavior).calculate
    when 'service_digital'
      TaxDigitalService.new(@buyer_type, @buyer_country, @amount, @tax_behavior).calculate
    when 'service_onsite'
      TaxOnsiteService.new(@buyer_type, @buyer_country, @amount, @tax_behavior).calculate
    else
      raise StandardError, 'Invalid Transaction Type'
    end
  end
end
