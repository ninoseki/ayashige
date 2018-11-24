# frozen_string_literal: true

require "json"

module Ayashige
  class Store
    def initialize
      @client = Redis.client
    end

    def store(updated, domain)
      @client.multi do
        @client.sadd updated, domain.to_s
        @client.expire updated, 60 * 60 * 48
      end
    end

    def get(key)
      @client.smembers(key)
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
