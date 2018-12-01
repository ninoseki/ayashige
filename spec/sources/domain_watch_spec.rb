# frozen_string_literal: true

require "mock_redis"

RSpec.describe Ayashige::Sources::DomainWatch, :vcr do
  subject { Ayashige::Sources::DomainWatch.new }

  let(:redis) { MockRedis.new }

  before do
    allow(Ayashige::Redis).to receive(:client).and_return(redis)
  end

  after do
    redis.flushdb
  end

  describe "#records" do
    it "should return records as an Array" do
      records = subject.records
      expect(records).to be_an(Array)
      records.each do |record|
        expect(record["domain"]).to be_a(String)
        expect(record["added_at"]).to be_a(String)
      end
    end
  end

  describe "#store_newly_registered_domains" do
    before do
      allow(subject).to receive(:records).and_return(
        [
          {
            "domain" => "paypal.pay.pay.world",
            "added_at" => "2018-12-01 01:43:17"
          },
        ]
      )
    end

    it "should store parsed domains into Redis" do
      output = capture(:stdout) { subject.store_newly_registered_domains }
      expect(output).to include("paypal.pay.pay.world")
      expect(redis.exists("2018-12-01")).to eq(true)
    end
  end
end
