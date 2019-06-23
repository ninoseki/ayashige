# frozen_string_literal: true

require "mock_redis"

RSpec.describe Ayashige::Store do
  subject { described_class.new }

  let(:redis) { MockRedis.new }

  let(:sample) {
    {
      domain: "test.com",
      score: 80,
      updated_on: "2018-01-01",
      source: "test"
    }
  }

  before do
    allow(Ayashige::Redis).to receive(:client).and_return(redis)
  end

  after do
    redis.flushdb
  end

  describe "#store" do
    it "stores arguments as a Hash" do
      subject.store(sample)
      expect(redis.hgetall("test.com")).to eq(
        "score" => "80",
        "updated_on" => "2018-01-01",
        "source" => "test"
      )
    end

    context "when ENV['DEFAULT_TTL'] is present" do
      before do
        allow(ENV).to receive(:[]).with("DEFAULT_TTL").and_return(100)
      end

      it "stores arguments as a Hash with TTL = 100" do
        subject.store sample
        expect(redis.ttl("test.com")).to be_between(1, 100)
      end
    end
  end

  describe "#get" do
    it "returns a Hash value" do
      redis.hmset "test.com", "score", 80, "updated_on", "2018-01-01", "source", "test"
      redis.hmset "test2.com", "score", 80, "updated_on", "2018-01-02", "source", "test"
      expect(subject.get("test.com")).to eq(
        "score" => "80",
        "updated_on" => "2018-01-01",
        "source" => "test"
      )
    end
  end

  describe "#keys" do
    before do
      redis.set "key1", "test"
      redis.set "key2", "test"
    end

    it "returns keys" do
      expect(subject.keys).to eq(["key1", "key2"])
    end
  end

  describe "#all" do
    before do
      redis.hmset "test.com", "score", 80, "updated_on", "2018-01-01", "source", "test"
      redis.hmset "test2.com", "score", 80, "updated_on", "2018-01-02", "source", "test"
    end

    it "returns all data as a Hash" do
      expect(subject.all).to eq(
        "test.com" => { "score" => "80", "updated_on" => "2018-01-01", "source" => "test" },
        "test2.com" => { "score" => "80", "updated_on" => "2018-01-02", "source" => "test" }
      )
    end
  end

  describe "#exists?" do
    context "when a given key exists" do
      before { redis.set "test", "value" }

      it "returns true" do
        expect(subject.exists?("test")).to eq(true)
      end
    end

    context "when a given key not exists" do
      it "returns false" do
        expect(subject.exists?("test")).to eq(false)
      end
    end
  end
end
