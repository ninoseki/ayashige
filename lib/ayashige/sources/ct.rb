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
      end
    end

    class CT < Source
      CTL_LIST = "https://www.gstatic.com/ct/log_list/all_logs_list.json"
      BAD_CTL_SERVERS = [
        "alpha.ctlogs.org/", "clicky.ct.letsencrypt.org/", "ct.akamai.com/", "ct.filippo.io/behindthesofa/",
        "ct.gdca.com.cn/", "ct.izenpe.com/", "ct.izenpe.eus/", "ct.sheca.com/", "ct.startssl.com/", "ct.wosign.com/",
        "ctserver.cnnic.cn/", "ctlog.api.venafi.com/", "ctlog.gdca.com.cn/", "ctlog.sheca.com/", "ctlog.wosign.com/",
        "ctlog2.wosign.com/", "flimsy.ct.nordu.net:8080/", "log.certly.io/", "nessie2021.ct.digicert.com/log/",
        "plausible.ct.nordu.net/", "www.certificatetransparency.cn/ct/", "ct.googleapis.com/testtube/",
        "ct.googleapis.com/daedalus/"
      ].freeze

      def initialize
        super
        @cache = FileCache.new("ct")
      end

      def ctl_servers
        @ctl_servers ||= [].tap do |servers|
          res = HTTP.get(CTL_LIST)
          json = JSON.parse(res.body.to_s)
          logs = json.dig("logs")
          break unless logs

          logs.each do |log|
            url = log.dig("url")
            next unless url || BAD_CTL_SERVERS.include?(url)

            # remove "/" from end of url
            servers << CTLServer.new("https://#{url[0..-2]}", @cache)
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
        domain = cn[1]
        domain.gsub /\*\./, ""
      end

      def all_x509_entries
        ctl_servers.map do |ctl_server|
          entries << ctl_server.x509_entries
        rescue StandardError => _
          []
        end.flatten
      end

      def records
        all_x509_entries.map do |entry|
          Record.new(
            domain_name: get_domain_name(entry.leaf_input.timestamped_entry.x509_entry.subject),
            updated: entry.leaf_input.timestamped_entry.timestamp.to_s
          )
        rescue NoMethodError => _
          nil
        end.compact
      end
    end
  end
end
