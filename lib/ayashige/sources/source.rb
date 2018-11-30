# frozen_string_literal: true

require "http"
require "oga"
require "date"

module Ayashige
  module Sources
    class Source
      def initialize
        @store = Store.new
      end

      def store_newly_registered_domains
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      private

      def store_domain(updated_on, domain)
        domain = Domain.new(domain)
        return unless domain.suspicious?

        @store.store normalize_date(updated_on), domain.to_s, domain.score
        puts "#{self.class}: #{domain} is stored."
      rescue ArgumentError => e
        puts e
      end

      def normalize_date(date)
        d = Date.parse(date)
        d.strftime "%Y-%m-%d"
      end

      def html2doc(html)
        Oga.parse_html html
      rescue StandardError => _
        nil
      end

      def xml2doc(xml)
        Oga.parse_xml xml
      rescue StandardError => _
        nil
      end
    end
  end
end
