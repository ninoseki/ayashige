# frozen_string_literal: true

require "rack/test"
require "json"

RSpec.describe "Application" do
  include Rack::Test::Methods

  def app
    Ayashige::Application
  end

  describe "GET /" do
    it "should return 200 OK" do
      get "/"
      expect(last_response).to be_ok
    end
  end

  describe "GET /feed" do
    before do
      allow(Ayashige::Store).to receive(:all).and_return(
        "2018-01-01": ["paypal.pay.pay.com", "google.apple.microsoft.com"]
      )
    end

    it "should return 200 OK" do
      get "/feed"
      expect(last_response).to be_ok
      array = JSON.parse(last_response.body.to_s)
      expect(array).to be_a(Array)
      first = array.first
      expect(first["domain"]).to eq("paypal.pay.pay.com")
      expect(first["updated_on"]).to eq("2018-01-01")
      expect(first["score"]).to be_an(Integer)
    end
  end
end
