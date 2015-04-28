require 'rest_client'

class Fetcher

  class << self
    def fetch_currencies
      last_rates = Currency.order(:created_at).last

      last_rates && last_rates.created_at > 1.hour.ago ? last_rates : Currency.create(rates: new_rates)
    end

    private

    def new_rates
      response = RestClient.get(ENV['CURRENCY_ENDPOINT']);
      JSON.parse(response)['rates']
    end
  end
end