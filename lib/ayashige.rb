# frozen_string_literal: true

require "ayashige/version"

require "ayashige/utility"
require "ayashige/domain"

require "ayashige/redis"

require "ayashige/store"

require "ayashige/sources/web_analyzer"

require "ayashige/application"

require "ayashige/jobs/cron_job"

require "rollbar"
require "dotenv/load"

Rollbar.configure do |config|
  config.access_token = ENV["ROLLBAR_ACCESS_TOKEN"]
end

module Ayashige
  class Error < StandardError; end
end
