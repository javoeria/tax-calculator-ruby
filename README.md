# Tax calculator

This project is my submission to the coding challenge for a Senior Support Engineer position at Quaderno.

## Challenge

Implement a system that is capable of calculating taxes on the sales of products and services.

The multinational **Munchitos S.A.** is going to launch an online platform to sell a myriad of products and services:

1. **Food products** for both individual consumers and companies.
2. **Digital subscription services**, which include access to exclusive content and resources for professionals in the foodservice industry.
3. **In-person training courses** for chefs and restaurants, organized in various cities.

**Munchitos S.A.** has contacted Quaderno to integrate an automated system for calculating taxes on sales made on its platform, and thus be able to comply with the tax regulations of each country.

Your duty is to design and implement this system. The software must be able to calculate the right taxes based on the rules described below.

> [!NOTE]
> To simplify the requirements, we will assume that the seller, **Munchitos S.A.**, is a company operating from Spain, a member country of the European Union (EU).

* Sale of physical products:
  * The type of transaction shall be marked as **‘good’**.
  * If the buyer is in Spain:
    * Spanish VAT will be applied, regardless of whether it is an individual consumer or a company.
  * If the buyer is outside Spain, but in an EU country:
    * In the case of an individual consumer, the local VAT of the buyer's country will be applied.
    * If the buyer is a company, no VAT will be applied and the transaction will be marked as a **‘reverse charge’**.
  * If the buyer is in a country outside the EU:
    * No tax will be applied. The transaction will be marked as **‘export’**. The buyer will be responsible for taxes and duties in their country.
* Sale of digital services:
  * The type of transaction shall be marked as **‘service’** and **'digital'**.
  * If the buyer is in Spain:
    * Spanish VAT will be applied, regardless of whether it is an individual consumer or a company.
  * If the buyer is outside Spain, but in an EU country:
    * In the case of an individual consumer, the local VAT of the buyer's country will be applied.
    * If the buyer is a company, no VAT will be applied and the transaction will be marked as a **‘reverse charge’**.
  * If the buyer is in a country outside the EU:
    * No tax will be applied.
* Sale of onsite services:
  * The type of transaction shall be marked as **‘service’** and **'onsite'**.
  * The **Spanish VAT** will be applied if the service is provided in Spain, regardless of where the buyer is located, and regardless of whether the buyer is an individual consumer or a company. In this case, the place where the service is provided (where the course takes place) defines the applicable tax.

## How to setup

The REST API application is created with Ruby 3.3.3 and Rails 7.1.4.

First, you need to run the following commands to install dependencies and run the server:

```
bundle install
rails server
```

## API endpoint

I have created a GET route `/api/v1/tax_rates/calculate` to calculate a tax rate using API versioning and query parameters. For example:

```
http://localhost:3000/api/v1/tax_rates/calculate?transaction_type=good&buyer_type=individual&buyer_country=ES&amount=100
```

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| `transaction_type` | `string` | **Required**. Must be one of 'good', 'service_digital', 'service_onsite' |
| `buyer_type`       | `string` | **Required**. Must be one of 'individual', 'company' |
| `buyer_country`    | `string` | **Required**. ISO country code by alpha-2 |
| `amount`           | `string` | **Required**. Amount of the transaction |
| `tax_behavior`     | `string` | **Optional**. Must be one of 'inclusive', 'exclusive' |

The controller `TaxRatesController` has only one method that calls to the service `TaxRateService`, which performs the tax calculation. The response body has the following JSON format:

```
{
  "data": {
    "status": "taxable",
    "country": "ES",
    "tax_rate": 21,
    "tax_amount": 21.0,
    "subtotal": 100.0,
    "total_amount": 121.0,
  }
}
```

Also, I have used [Apipie gem](https://github.com/Apipie/apipie-rails) to describe endpoints and validate parameters. The documentation is available in `/apipie` route.

## Run tests

I have created 12 tests with 50 assertions in total using Minitest, each targeting different workflows for comprehensive validation.

Run all tests with the following command:

```
rails test
```

Also, I have used [SimpleCov gem](https://github.com/simplecov-ruby/simplecov) to gather code coverage data of services and controllers, which shows 100%.

**THANKS FOR READING!!**
