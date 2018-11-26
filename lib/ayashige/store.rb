# frozen_string_literal: true

require "json"

module Ayashige
  DEFAULT_TTL = 60 * 60 * 48

  class Store
    def initialize
      @client = Redis.client
    end

    def store(key, field, value)
      @client.multi do
        @client.hset key, field, value
        @client.expire key, DEFAULT_TTL
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
