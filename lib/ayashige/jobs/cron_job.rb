# frozen_string_literal: true

module Ayashige
  module Jobs
    class CronJob
      def perform
        Sources::WebAnalyzer.new.store_newly_registered_domains
      end
    end
  end
end
