# frozen_string_literal: true

require "ayashige/version"

require "ayashige/utility"
require "ayashige/domain"

require "ayashige/redis"

require "ayashige/store"

require "ayashige/sources/web_analyzer"

require "ayashige/application"

require "ayashige/jobs/cron_job"

module Ayashige
  class Error < StandardError; end
end
