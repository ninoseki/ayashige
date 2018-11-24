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
        "2018-01-01": ["test.com", "example.com"]
      )
    end

    it "should return 200 OK" do
      get "/feed"
      expect(last_response).to be_ok
      json = JSON.parse(last_response.body.to_s)
      expect(json).to be_a(Hash)
      expect(json.keys).to eq(["2018-01-01"])
    end
  end
end
