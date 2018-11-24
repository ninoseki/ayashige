# frozen_string_literal: true

require "redis"

module Ayashige
  module Redis
    def self.client
      @client ||= ::Redis.new(
        host: (ENV['REDIS_HOST'] || 'localhost'),
        port: ENV["REDIS_PORT"],
        password: ENV['REDIS_PASSWORD'] || ''
      )
    end
  end
end
