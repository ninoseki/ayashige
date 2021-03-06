# frozen_string_literal: true

require "date"
require "parallel"
require "securitytrails"

module Ayashige
  module Sources
    class SecurityTrails < Source
      def initialize
        super

        @api = ::SecurityTrails::API.new
      end

      def store_newly_registered_domains
        Parallel.each(records) { |record| store record }
      end

      def records
        domains = @api.feeds.domains("new")
        date = DateTime.now.to_s
        domains.map do |domain|
          Record.new( domain_name: domain, updated: date)
        end
      end
    end
  end
end
