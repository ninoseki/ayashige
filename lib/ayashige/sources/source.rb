# frozen_string_literal: true

require "http"
require "oga"

module Ayashige
  module Sources
    class Source
      def initialize
        @store = Store.new
      end

      def name
        self.class.to_s.split("::").last
      end

      def store_newly_registered_domains
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      private

      def store(record)
        return unless record.domain.suspicious?

        @store.store(
          domain: record.domain.to_s,
          score: record.domain.score,
          source: name,
          updated_on: record.updated_on
        )
        puts "#{self.class}: #{record.domain} is stored."
      rescue ArgumentError => e
        puts e
      end

      def html2doc(html)
        Oga.parse_html html
      rescue StandardError => e
        nil
      end

      def xml2doc(xml)
        Oga.parse_xml xml
      rescue StandardError => e
        nil
      end
    end
  end
end
