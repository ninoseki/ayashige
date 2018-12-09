# frozen_string_literal: true

require "mock_redis"

RSpec.describe Ayashige::Sources::CT, :vcr do
  subject { Ayashige::Sources::CT.new }

  let(:redis) { MockRedis.new }

  before do
    allow(Ayashige::Redis).to receive(:client).and_return(redis)
  end

  after do
    redis.flushdb
  end

  describe "#x509_entries" do
    it "should return an Array of CT log entries which have x509 entry" do
      subject.x509_entries.each do |entry|
        expect(entry.leaf_input.timestamped_entry.x509_entry).to be_a(OpenSSL::X509::Certificate)
      end
    end
  end

  describe "#records" do
    it "should return an Array of records" do
      subject.records.each do |record|
        expect(record.domain).to be_a(Ayashige::Domain)
        expect(record.updated_on).to be_a(String)
      end
    end
  end

  describe "#store_newly_registered_domains" do
    let(:updated_on) { "2018-01-01" }

    before do
      allow(subject).to receive(:records).and_return(
        [
          Ayashige::Record.new(updated: "2018-01-01 11:11:14 +0900", domain_name: "paypal.pay.pay.world")
        ]
      )
    end

    it "should store parsed domains into Redis" do
      output = capture(:stdout) { subject.store_newly_registered_domains }
      expect(output.include?("paypal.pay.pay.world")).to eq(true)

      expect(redis.exists(updated_on)).to eq(true)
    end
  end
end
