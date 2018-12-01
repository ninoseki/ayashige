# frozen_string_literal: true

require "ayashige/version"

require "ayashige/utility"
require "ayashige/domain"

require "ayashige/redis"

require "ayashige/store"

require "ayashige/sources/source"
require "ayashige/sources/domain_watch"
require "ayashige/sources/web_analyzer"
require "ayashige/sources/whoisds"

require "ayashige/jobs/job"
require "ayashige/jobs/domain_watch"
require "ayashige/jobs/web_analyzer"
require "ayashige/jobs/whoisds"

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
