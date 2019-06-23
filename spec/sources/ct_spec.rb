# frozen_string_literal: true

require "filecache"
require "fileutils"
require "mock_redis"

RSpec.describe Ayashige::Sources::CTLogServer, :vcr do
  let(:cache) { double("cache") }

  before do
    allow(cache).to receive(:get).and_return(0)
    allow(cache).to receive(:set)
  end

  subject { Ayashige::Sources::CTLogServer.new("https://ct.googleapis.com/logs/argon2020", cache) }

  describe "#x509_entries" do
    it "returns an Array of CT log entries which have x509 entry" do
      subject.x509_entries.each do |entry|
        expect(entry.leaf_input.timestamped_entry.x509_entry).to be_a(OpenSSL::X509::Certificate)
      end
    end
  end
end

RSpec.describe Ayashige::Sources::CT, :vcr do
  include_context "source context"

  subject { Ayashige::Sources::CT.new }

  describe "#ct_log_servers" do
    it "returns an Array of CTLServer" do
      servers = subject.ct_log_servers
      expect(servers).to be_an(Array)
      expect(servers.first).to be_an(Ayashige::Sources::CTLogServer)
    end
  end

  describe "#records" do
    before do
      stub_const("Ayashige::Sources::CTLServer::LIMIT", 10)

      cache_dir = File.expand_path("../../tmp/cache", __dir__)
      Dir.exist?(cache_dir) ? FileUtils.rm_r(cache_dir) : FileUtils.mkdir_p(cache_dir)
      cache = FileCache.new("test", cache_dir)
      ct_log_servers = [
        Ayashige::Sources::CTLogServer.new("https://ct.googleapis.com/logs/argon2019", cache),
        Ayashige::Sources::CTLogServer.new("https://ct.googleapis.com/logs/argon2020", cache),
      ]
      allow(subject).to receive(:ct_log_servers).and_return(ct_log_servers)
    end

    it "returns an Array of records" do
      records = subject.records
      expect(records).to be_an(Array)
      expect(records).not_to be_empty

      records.each do |record|
        expect(record.domain).to be_a(Ayashige::Domain)
        expect(record.updated_on).to be_a(String)
      rescue ArgumentError => _e
        next
      end
    end
  end

  describe "#name" do
    it "returns a name of the class" do
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
