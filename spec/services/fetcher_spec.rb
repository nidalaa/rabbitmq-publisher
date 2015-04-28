require "rails_helper"

describe Fetcher do
  describe "::fetch_currencies" do
    before do
      stub_request(:get, %r{https://openexchangerates.org/api/latest.json*}).
                to_return(:status => 200, :body => { "rates" => { "EUR" => 4.27 } }.to_json)
    end

    it "adds Currency record after initial request" do
      expect { Fetcher.fetch_currencies }.to change { Currency.count }.by(1)
    end

    describe "first request in last hour" do
      it "adds new record to database" do
        Currency.create(rates: { example: 21 }, created_at: 1.hour.ago)

        expect { Fetcher.fetch_currencies }.to change { Currency.count }.by(1)
      end
    end

    describe "second request in last hour" do
      let!(:recent_rates) { Currency.create(rates: { example: 21 }, created_at: 10.minutes.ago) }

      it "returns last record" do
        Currency.create(rates: { example: 21 }, created_at: 15.minutes.ago)
        expect(Fetcher.fetch_currencies).to eq(recent_rates)
      end

      it "does not call external API" do
        rest_client = class_spy("RestClient")

        Fetcher.fetch_currencies
        expect(rest_client).to_not have_received(:get)
      end

      it "does not add new record to database" do
        expect { Fetcher.fetch_currencies }.to change { Currency.count }.by(0)
      end
    end 
  end
end
