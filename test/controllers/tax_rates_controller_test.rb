require "test_helper"

class TaxRatesControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::TaxRatesController.new
  end

  test "returns a tax calculation json" do
    get(:calculate, params: { transaction_type: 'good', buyer_type: 'individual', buyer_country: 'ES', amount: 100, tax_behavior: 'inclusive' })
    data = JSON.parse(@response.body)['data']
    assert_response 200
    assert_equal('taxable', data['status'])
    assert_equal(data['tax_amount'] + data['subtotal'], data['total_amount'])
  end

  test "should have required params" do
    assert_raises(Apipie::ParamMultipleMissing) do
      get(:calculate, params: {})
    end
  end

  test "should have valid params" do
    assert_raises(Apipie::ParamInvalid) do
      get(:calculate, params: { transaction_type: 'a', buyer_type: 'individual', buyer_country: 'ES', amount: 100 })
    end
  end
end
