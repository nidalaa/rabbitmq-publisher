require 'rest_client'

class Fetcher

  class << self
    def fetch_currencies
      return Currency.last if Currency.last && Currency.last.created_at > 1.hour.ago

      Currency.create(rates: new_rates, key: SecureRandom.uuid)
    end

    private

    def new_rates
      response = RestClient.get(ENV['CURRENCY_ENDPOINT']);
      JSON.parse(response)['rates']
    end
  end
end