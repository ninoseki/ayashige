# frozen_string_literal: true

module Ayashige
  module Jobs
    class CronJob
      def perform
        store_newly_registered_domains
      end

      def store_newly_registered_domains
        Sources::WebAnalyzer.new.store_newly_registered_domains
      end
    end
  end
end
