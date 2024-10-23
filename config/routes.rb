Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  apipie
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      get 'tax_rates/calculate', to: 'tax_rates#calculate'
    end
  end
end
