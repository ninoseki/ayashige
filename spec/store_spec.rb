# frozen_string_literal: true

require "mock_redis"

RSpec.describe Ayashige::Store do
  subject { Ayashige::Store.new }

  let(:redis) { MockRedis.new }

  before do
    allow(Ayashige::Redis).to receive(:client).and_return(redis)
  end

  after do
    redis.flushdb
  end

  describe "#store" do
    it "should store arguments as a Hash" do
      subject.store "2018-01-01", "test.com", 80
      expect(redis.hgetall("2018-01-01")).to eq("test.com" => "80")
    end

    context "when ENV['DEFAULT_TTL'] is present" do
      before do
        allow(ENV).to receive(:[]).with("DEFAULT_TTL").and_return(100)
      end
      it "should store arguments as a Hash with TTL = 100" do
        subject.store "2018-01-01", "test.com", 80
        expect(redis.ttl("2018-01-01")).to be_between(1, 100)
      end
    end
  end

  describe "#get" do
    it "should return a Hash value" do
      redis.hset "2018-01-01", "test.com", 80
      redis.hset "2018-01-01", "test2.com", 80
      expect(subject.get("2018-01-01")).to eq(
        "test.com" => "80",
        "test2.com" => "80"
      )
    end
  end

  describe "#keys" do
    before do
      redis.set "key1", "test"
      redis.set "key2", "test"
    end
    it "should return keys" do
      expect(subject.keys).to eq(["key1", "key2"])
    end
  end

  describe "#all" do
    before do
      redis.hset "2018-01-01", "test.com", 80
      redis.hset "2018-01-02", "test2.com", 80
    end
    it "should return all data as a Hash" do
      expect(subject.all).to eq(
        "2018-01-01" => { "test.com" => "80" },
        "2018-01-02" => { "test2.com" => "80" }
      )
    end
  end

  describe "#exists?" do
    context "when a given key is exist" do
      before { redis.set "test", "value" }
      it "should return true" do
        subject.exists? "test"
      end
    end
    context "when a given key is not exist" do
      it "should return true" do
        subject.exists? "not_exists"
      end
    end
  end
end
