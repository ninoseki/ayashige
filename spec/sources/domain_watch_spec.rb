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

  describe "#get_records_from_doc" do
    it "should return domains in a page as an Array" do
      page = subject.get_page(1)
      records = subject.get_records_from_doc(page)

      expect(records.length).to eq(100)
      records.each do |record|
        expect(record.domain).to be_a(Ayashige::Domain)
        expect(record.updated_on).to be_a(String)
      end
    end
  end

  describe "#store_newly_registered_domains" do
    before do
      stub_const("Ayashige::Sources::DomainWatch::LIMIT", 2)

      allow(subject).to receive(:get_page).and_return(nil)
      allow(subject).to receive(:get_records_from_doc).and_return(
        [
          Ayashige::Record.new(updated: updated_on, domain_name: "paypal.pay.pay.world")
        ]
      )
      allow(Parallel).to receive(:map).with(1..2).and_yield([1, 2])
    end

    include_examples "#store_newly_registered_domains example"
  end
end
