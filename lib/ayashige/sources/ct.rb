# frozen_string_literal: true

require "certificate-transparency-client"

module Ayashige
  module Sources
    class CT < Source
      BASE_URL = "https://ct.googleapis.com/rocketeer"
      LIMIT = 10_000

      def initialize
        super

        @ct = CertificateTransparency::Client.new(BASE_URL)
      end

      def name
        "CT(Google Rocketeer)"
      end

      def store_newly_registered_domains
        records.each { |record| store record }
      end

      def sth
        @sth ||= @ct.get_sth
      end

      def get_domain_name(subject)
        cn = subject.to_a.find { |a| a.first == "CN" }
        cn[1]
      end

      def x509_entries
        @x509_entries ||= @ct.get_entries(sth.tree_size - LIMIT, sth.tree_size).select do |entry|
          entry.leaf_input.timestamped_entry.x509_entry
        end
      end

      def records
        x509_entries.map do |entry|
          Record.new(
            domain_name: get_domain_name(entry.leaf_input.timestamped_entry.x509_entry.subject),
            updated: entry.leaf_input.timestamped_entry.timestamp.to_s
          )
        end
      end
    end
  end
end
