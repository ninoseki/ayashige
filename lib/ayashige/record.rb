# frozen_string_literal: true

require "date"

module Ayashige
  class Record
    def initialize(updated:, domain_name:)
      @updated = updated
      @domain_name = domain_name
    end

    def updated_on
      @updated_on ||= normalize_date(@updated)
    end

    def domain
      @domain ||= Domain.new(@domain_name)
    end

    private

    def normalize_date(date)
      Date.parse(date).strftime("%Y-%m-%d")
    end
  end
end
