# frozen_string_literal: true

require "ayashige/version"

require "ayashige/utility"
require "ayashige/domain"
require "ayashige/record"

require "ayashige/redis"

require "ayashige/store"

require "ayashige/sources/source"
require "ayashige/sources/ct"
require "ayashige/sources/securitytrails"

require "ayashige/jobs/job"
require "ayashige/jobs/ct"
require "ayashige/jobs/securitytrails"

require "ayashige/rollbar"

require "ayashige/application"

require "rollbar"

if Ayashige::Rollbar.available?
  Rollbar.configure do |config|
    config.access_token = ENV["ROLLBAR_ACCESS_TOKEN"]
  end
end

module Ayashige
  class Error < StandardError; end
end
