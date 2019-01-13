# frozen_string_literal: true

require "certificate-transparency-client"
require "filecache"
require "http"

module Ayashige
  module Sources
    class CTLServer
      LIMIT = 1_000
      attr_reader :url

      def initialize(url, cache)
        @url = url
        @cache = cache
      end

      def x509_entries
        ct = CertificateTransparency::Client.new(url)
        sth = ct.get_sth

        cached_tree_size = @cache.get(url) || sth.tree_size - LIMIT
        cached_tree_size = 0 if cached_tree_size.negative?

        entries = ct.get_entries(cached_tree_size, sth.tree_size).select do |entry|
          entry.leaf_input.timestamped_entry.x509_entry
        end

        @cache.set(url, sth.tree_size)

        entries
      rescue StandardError => _
        []
      end
    end

    class CT < Source
      CTL_LIST = "https://ct.grahamedgecombe.com/logs.json"

      def initialize(cache_dir = "/tmp")
        super()
        @cache = FileCache.new("ct", cache_dir)
      end

      def config
        @config ||= YAML.safe_load File.read(File.expand_path("./../config/ct.yml", __dir__))
      end

      def ctl_servers
        @ctl_servers ||= [].tap do |servers|
          urls = config.dig("ct_log_servers") || []
          urls.each do |url|
            servers << CTLServer.new(url, @cache)
          end
        end
      end

      def name
        "CT log"
      end

      def store_newly_registered_domains
        records.each { |record| store record }
      end

      def get_domain_name(subject)
        cn = subject.to_a.find { |a| a.first == "CN" }
        return nil unless cn

        domain = cn[1]
        domain.gsub /\*\./, ""
      end

      def all_x509_entries
        ctl_servers.map(&:x509_entries).flatten
      end

      def records
        all_x509_entries.map do |entry|
          domain_name = get_domain_name(entry.leaf_input.timestamped_entry.x509_entry.subject)
          next unless domain_name

          Record.new(
            domain_name: domain_name,
            updated: entry.leaf_input.timestamped_entry.timestamp.to_s
          )
        end.compact
      end
    end
  end
end
