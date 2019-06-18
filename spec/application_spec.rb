# frozen_string_literal: true

require "rack/test"
require "json"

RSpec.describe "Application" do
  include Rack::Test::Methods

  def app
    Ayashige::Application
  end

  describe "GET /" do
    it "returns 200 OK" do
      get "/"
      expect(last_response).to be_ok
    end
  end

  describe "GET /feed" do
    before do
      allow(Ayashige::Store).to receive(:all).and_return(
        "test.com" => { "score" => "80", "updated_on" => "2018-01-01", "source" => "test" },
        "test2.com" => { "score" => "80", "updated_on" => "2018-01-02", "source" => "test" }
      )
    end

    it "returns 200 OK and JSON response" do
      get "/feed"
      expect(last_response).to be_ok
      array = JSON.parse(last_response.body.to_s)
      expect(array).to be_a(Array)

      first = array.first
      expect(first["domain"]).to eq("test.com")
      expect(first["updated_on"]).to eq("2018-01-01")
      expect(first["score"]).to be_an(Integer)
      expect(first["source"]).to be_a(String)

      last = array.last
      expect(last["domain"]).to eq("test2.com")
      expect(last["updated_on"]).to eq("2018-01-02")
      expect(last["score"]).to be_an(Integer)
      expect(last["source"]).to be_a(String)
    end
  end

  describe "GET /404" do
    it "redirects to the root" do
      get "/404"
      expect(last_response.status).to eq(302)
      expect(last_response.headers["Location"]).to eq("http://example.org/")
    end
  end
end
