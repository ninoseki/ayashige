# frozen_string_literal: true

require "certificate-transparency-client"
require "set"

module Ayashige
  module Sources
    class CT < Source
      BASE_URL = "https://ct.googleapis.com/rocketeer"
      LIMIT = 5_000

      def initialize
        super

        @ct_log_servers = [
          "https://ct.googleapis.com/icarus",
          "https://ct.googleapis.com/pilot",
          "https://ct.googleapis.com/rocketeer",
          "https://ct.googleapis.com/logs/argon2019",
          "https://yeti2019.ct.digicert.com/log"
        ]
      end

      def name
        "CT log"
      end

      def store_newly_registered_domains
        records.each { |record| store record }
      end

      def get_domain_name(subject)
        cn = subject.to_a.find { |a| a.first == "CN" }
        domain = cn[1]
        domain.gsub /\*\./, ""
      end

      def x509_entries
        @x509_entries ||= [].tap do |entries|
          @ct_log_servers.each do |ct_log_server|
            ct = CertificateTransparency::Client.new(ct_log_server)
            sth = ct.get_sth
            entries << ct.get_entries(sth.tree_size - LIMIT, sth.tree_size).select do |entry|
              entry.leaf_input.timestamped_entry.x509_entry
            end
          end
        end.flatten
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
