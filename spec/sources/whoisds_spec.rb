# frozen_string_literal: true

require "mock_redis"

RSpec.describe Ayashige::Sources::WhoisDS, :vcr do
  subject { Ayashige::Sources::WhoisDS.new }

  let(:redis) { MockRedis.new }

  before do
    allow(Ayashige::Redis).to receive(:client).and_return(redis)
  end

  after do
    redis.flushdb
  end

  describe "#latest_zip_file_link" do
    it "should return a link of the latest zip file as a String" do
      expect(subject.latest_zip_file_link).to be_a(String)
      expect(subject.latest_zip_file_link).to include "https://whoisds.com//whois-database/newly-registered-domains"
    end
  end

  describe "#latest_indexed_date" do
    it "should return the latest indexed date as a String" do
      expect(subject.latest_indexed_date).to be_a(String)
    end
  end

  describe "#unzip" do
    it "should unzip a given zip file and extract its contents" do
      data = File.read(File.expand_path("../fixtures/archive.zip", __dir__))
      lines = subject.unzip(data)
      expect(lines).to eq(["test.com", "test2.com", "test3.com"])
    end
  end

  describe "#store_newly_registered_domains" do
    let(:updated_on) { "2018-01-01" }

    before do
      allow(subject).to receive(:latest_indexed_date).and_return(updated_on)
      allow(subject).to receive(:latest_zip_file_link).and_return("https://whoisds.com//whois-database/newly-registered-domains/MjAxOC0xMS0yNi56aXA=/nrd")
      allow(subject).to receive(:unzip).and_return(["paypal.pay.pay.world"])
    end

    it "should store parsed domains into Redis" do
      output = capture(:stdout) { subject.store_newly_registered_domains }
      expect(output.include?("paypal.pay.pay.world")).to eq(true)

      expect(redis.exists(updated_on)).to eq(true)
    end
  end
end
