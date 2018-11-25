# frozen_string_literal: true

require "mock_redis"

RSpec.describe Ayashige::Sources::WebAnalyzer, :vcr do
  subject { Ayashige::Sources::WebAnalyzer.new }

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
end
