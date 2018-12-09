# frozen_string_literal: true

module Ayashige
  module Jobs
    class Job
      def perform
        with_error_handling { @source.store_newly_registered_domains }
      end

      def with_error_handling
        yield
      rescue StandardError => e
        if Ayashige::Rollbar.available?
          Rollbar.error e
        else
          puts e
        end
      end
    end
  end
end
