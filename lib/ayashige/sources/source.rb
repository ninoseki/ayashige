# frozen_string_literal: true

require "http"
require "oga"

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
