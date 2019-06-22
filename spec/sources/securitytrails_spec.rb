# frozen_string_literal: true

require "mock_redis"

RSpec.describe Ayashige::Sources::SecurityTrails do
  subject { described_class.new }

  let(:redis) { MockRedis.new }

  before do
    allow(Ayashige::Redis).to receive(:client).and_return(redis)
  end

  after do
    redis.flushdb
  end

  describe "#get_records" do
    before do
      mock = double("Feeds API")
      allow(mock).to receive(:domains).and_return(["example.com"])
      allow(SecurityTrails::Clients::Feeds).to receive(:new).and_return(mock)
    end

    it do
      records = subject.records
      records.each do |record|
        expect(record.domain).to be_a(Ayashige::Domain)
        expect(record.updated_on).to be_a(String)
      end
    end
  end

  describe "#store_newly_registered_domains" do
    before do
      allow(subject).to receive(:records).and_return(records)
    end

    include_examples "#store_newly_registered_domains example"
  end
end
