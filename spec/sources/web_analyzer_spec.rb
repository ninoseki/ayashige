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

  describe "#already_stored?" do
    context "when already stored" do
      before { redis.set "2018-01-01", "set" }
      it "should return true" do
        expect(subject.already_stored?("2018-01-01")).to eq(true)
      end
    end
    context "when not already stored" do
      it "should return false" do
        expect(subject.already_stored?("2018-01-01")).to eq(false)
      end
    end
  end

  describe "#latest_indexed_date" do
    it "should return the latest indexed date as a String" do
      expect(subject.latest_indexed_date).to be_a(String)
    end
  end

  describe "#get_domains_from_doc" do
    it "should return domains in a page as an Array" do
      page = subject.get_page("2018-11-22", "com", "1")
      domains = subject.get_domains_from_doc(page)

      expect(domains.length).to eq(99)
      domains.each do |domain|
        expect(domain.key?(:domain)).to eq(true)
        expect(domain.key?(:updated)).to eq(true)
      end
    end
  end

  describe "#get_links_from_doc" do
    it "should return links in a page as an Array" do
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
    let(:updated_on) { "2018-01-01" }

    before do
      stub_const("Ayashige::Sources::WebAnalyzer::LIMIT", 2)
      stub_const("Ayashige::Sources::WebAnalyzer::TLDS", ["world"])

      allow(subject).to receive(:latest_indexed_date).and_return("2018-11-23")
      allow(subject).to receive(:get_page).and_return(nil)
      allow(subject).to receive(:get_domains_from_doc).and_return([
        { updated: updated_on, domain: "paypal.pay.pay.world" }
      ])

      allow(Parallel).to receive(:each).with(["world"]).and_yield("world")
    end

    it "should store parsed domains into Redis" do
      output = capture(:stdout) { subject.store_newly_registered_domains }
      expect(output.include?("paypal.pay.pay.world")).to eq(true)

      expect(redis.exists(updated_on)).to eq(true)
    end
  end
end
