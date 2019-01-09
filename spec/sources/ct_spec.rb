# frozen_string_literal: true

require "mock_redis"
require "fileutils"

RSpec.describe Ayashige::Sources::CTLServer, :vcr do
  let(:cache) { double("cache") }

  before do
    allow(cache).to receive(:get).and_return(0)
    allow(cache).to receive(:set)
  end

  subject { Ayashige::Sources::CTLServer.new("https://ct.googleapis.com/logs/argon2020", cache) }

  describe "#x509_entries" do
    it "should return an Array of CT log entries which have x509 entry" do
      subject.x509_entries.each do |entry|
        expect(entry.leaf_input.timestamped_entry.x509_entry).to be_a(OpenSSL::X509::Certificate)
      end
    end
  end
end

RSpec.describe Ayashige::Sources::CT, :vcr do
  subject { Ayashige::Sources::CT.new }

  let(:redis) { MockRedis.new }

  before do
    allow(Ayashige::Redis).to receive(:client).and_return(redis)
  end

  after do
    redis.flushdb
  end

  describe "#records" do
    before { FileUtils.rm_r("/tmp/ct") }
    it "should return an Array of records" do
      subject.records.each do |record|
        expect(record.domain).to be_a(Ayashige::Domain)
        expect(record.updated_on).to be_a(String)
      rescue ArgumentError => _
        next
      end
    end
  end

  describe "#name" do
    it "should return a name of the class" do
      expect(subject.name).to eq("CT log")
    end
  end

  describe "#store_newly_registered_domains" do
    before do
      allow(subject).to receive(:records).and_return(
        [
          Ayashige::Record.new(updated: "2018-01-01 11:11:14 +0900", domain_name: domain_name)
        ]
      )
    end

    include_examples "#store_newly_registered_domains example"
  end
end
