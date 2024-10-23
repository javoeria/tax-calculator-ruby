require "test_helper"

class TaxRateServiceTest < ActiveSupport::TestCase
  # Sale of physical products
  test "good sale in Spain" do
    data = TaxRateService.new('good', 'individual', 'ES', 100).calculate
    assert_equal('taxable', data[:status])
    assert_instance_of(Integer, data[:tax_rate])
    assert_instance_of(Float, data[:tax_amount])
    assert_instance_of(Float, data[:subtotal])
    assert_instance_of(Float, data[:total_amount])
  end

  test "good sale in EU country to individual" do
    data = TaxRateService.new('good', 'individual', 'IT', 100).calculate
    assert_equal('taxable', data[:status])
    assert_instance_of(Integer, data[:tax_rate])
    assert_instance_of(Float, data[:tax_amount])
    assert_instance_of(Float, data[:subtotal])
    assert_instance_of(Float, data[:total_amount])
  end

  test "good sale in EU country to company" do
    data = TaxRateService.new('good', 'company', 'IT', 100).calculate
    assert_equal('reverse_charge', data[:status])
    assert_equal(0, data[:tax_rate])
    assert_equal(0, data[:tax_amount])
    assert_instance_of(Float, data[:subtotal])
    assert_instance_of(Float, data[:total_amount])
  end

  test "good sale outside EU countries" do
    data = TaxRateService.new('good', 'individual', 'US', 100).calculate
    assert_equal('export', data[:status])
    assert_equal(0, data[:tax_rate])
    assert_equal(0, data[:tax_amount])
    assert_instance_of(Float, data[:subtotal])
    assert_instance_of(Float, data[:total_amount])
  end

  # Sale of digital services
  test "digital sale in Spain" do
    data = TaxRateService.new('service_digital', 'individual', 'ES', 100).calculate
    assert_equal('taxable', data[:status])
    assert_instance_of(Integer, data[:tax_rate])
    assert_instance_of(Float, data[:tax_amount])
    assert_instance_of(Float, data[:subtotal])
    assert_instance_of(Float, data[:total_amount])
  end

  test "digital sale in EU country to individual" do
    data = TaxRateService.new('service_digital', 'individual', 'IT', 100).calculate
    assert_equal('taxable', data[:status])
    assert_instance_of(Integer, data[:tax_rate])
    assert_instance_of(Float, data[:tax_amount])
    assert_instance_of(Float, data[:subtotal])
    assert_instance_of(Float, data[:total_amount])
  end

  test "digital sale in EU country to company" do
    data = TaxRateService.new('service_digital', 'company', 'IT', 100).calculate
    assert_equal('reverse_charge', data[:status])
    assert_equal(0, data[:tax_rate])
    assert_equal(0, data[:tax_amount])
    assert_instance_of(Float, data[:subtotal])
    assert_instance_of(Float, data[:total_amount])
  end

  test "digital sale outside EU countries" do
    data = TaxRateService.new('service_digital', 'individual', 'US', 100).calculate
    assert_equal('non_taxable', data[:status])
    assert_equal(0, data[:tax_rate])
    assert_equal(0, data[:tax_amount])
    assert_instance_of(Float, data[:subtotal])
    assert_instance_of(Float, data[:total_amount])
  end

  # Sale of onsite services
  test "onsite sale in Spain" do
    data = TaxRateService.new('service_onsite', 'individual', 'US', 100).calculate
    assert_equal('taxable', data[:status])
    assert_equal(ISO3166::Country.new('ES').vat_rates['standard'], data[:tax_rate])
    assert_instance_of(Float, data[:tax_amount])
    assert_instance_of(Float, data[:subtotal])
    assert_instance_of(Float, data[:total_amount])
  end
end
