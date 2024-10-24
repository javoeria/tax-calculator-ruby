module Api::V1
  class TaxRatesController < ApplicationController
    api :GET, '/tax_rates/calculate', 'Calculate a tax rate'
    param :transaction_type, ['good', 'service_digital', 'service_onsite'], required: true
    param :buyer_type, ['individual', 'company'], required: true
    param :buyer_country, ISO3166::Country.codes, required: true
    param :amount, String, required: true
    param :tax_behavior, ['inclusive', 'exclusive']
    def calculate
      data = TaxRateService.new(params[:transaction_type], params[:buyer_type], params[:buyer_country], params[:amount], params[:tax_behavior] || 'exclusive').calculate
      render json: { data: data }, status: :ok
    end
  end
end
