# frozen_string_literal: true

require "json"

module Ayashige
  DEFAULT_TTL = 60 * 60 * 24

  class Store
    def initialize
      @client = Redis.client
    end

    def default_ttl
      @default_ttl ||= (ENV["DEFAULT_TTL"] || DEFAULT_TTL).to_i
    end

    def store(domain:, score:, updated_on:, source:)
      return if exists?(domain)

      @client.multi do
        @client.hmset domain, "score", score, "updated_on", updated_on, "source", source
        @client.expire(domain, default_ttl)
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
