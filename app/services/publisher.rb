require 'rest_client'

class Publisher

  class << self
    def publish
      rates = Fetcher.fetch_currencies

      exchange = channel.fanout("currencies.fanout")
      exchange.publish(rates.to_json(only: [:key, :rates]))
    end

    private

    def channel
      @channel ||= connection.create_channel
    end

    def connection
      @connection ||= Bunny.new.tap do |c|
        c.start
      end
    end
  end
end