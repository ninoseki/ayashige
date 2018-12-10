# frozen_string_literal: true

require "json"

module Ayashige
  DEFAULT_TTL = 60 * 60 * 24

  class Store
    def initialize
      @client = Redis.client
    end

    def ttl
      @ttl ||= (ENV["DEFAULT_TTL"] || 60 * 60 * 24).to_i
    end

    def store(key, field, value)
      @client.multi do
        @client.hset key, field, value
        @client.expire key, ttl
      end
    end

    def exists?(key)
      @client.exists key
    end

    def get(key)
      @client.hgetall key
    end

    def keys
      @client.keys
    end

    def all
      keys.map { |key| [key, get(key)] }.to_h
    end

    def self.all
      new.all
    end
  end
end
