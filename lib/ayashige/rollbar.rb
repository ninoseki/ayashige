# frozen_string_literal: true

module Ayashige
  class Rollbar
    ROLLBAR_KEY = "ROLLBAR_ACCESS_TOKEN"

    def self.available?
      ENV.key? ROLLBAR_KEY
    end

    def self.error(err)
      ::Rollbar.error err
    end
  end
end
