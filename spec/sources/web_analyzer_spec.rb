# frozen_string_literal: true

require "mock_redis"

RSpec.describe Ayashige::Sources::WebAnalyzer, :vcr do
  subject { Ayashige::Sources::WebAnalyzer.new }

  let(:redis) { MockRedis.new }

  before do
    allow(Ayashige::Redis).to receive(:client).and_return(redis)
  end

  after do
    redis.flushdb
  end

  describe "#latest_indexed_date" do
    it "returns the latest indexed date as a String" do
      expect(subject.latest_indexed_date).to be_a(String)
    end
  end

  describe "#get_records_from_doc" do
    it "returns domains in a page as an Array" do
      page = subject.get_page("2018-11-22", "com", "1")
      records = subject.get_records_from_doc(page)

      expect(records.length).to eq(99)
      records.each do |record|
        expect(record.domain).to be_a(Ayashige::Domain)
        expect(record.updated_on).to be_a(String)
      end
    end
  end

  describe "#get_links_from_doc" do
    it "returns links in a page as an Array" do
      page = subject.get_page("2018-11-22", "com", "1")
      links = subject.get_links_from_doc(page)

      expect(links).to be_an(Array)
      expect(links.length).to eq(30)
      links.each do |link|
        expect(link.include?("/new-created-domains/")).to eq(true)
      end
    end
  end

  describe "#store_newly_registered_domains" do
    before do
      stub_const("Ayashige::Sources::WebAnalyzer::LIMIT", 2)
      stub_const("Ayashige::Sources::WebAnalyzer::TLDS", ["world"])

      allow(subject).to receive(:latest_indexed_date).and_return("2018-11-23")
      allow(subject).to receive(:get_page).and_return(nil)
      allow(subject).to receive(:get_records_from_doc).and_return(
        [
          Ayashige::Record.new(updated: updated_on, domain_name: "paypal.pay.pay.world")
        ]
      )
      allow(Parallel).to receive(:each).with(["world"]).and_yield("world")
    end

    include_examples "#store_newly_registered_domains example"
  end
end
