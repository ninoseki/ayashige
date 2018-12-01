# frozen_string_literal: true

module Ayashige
  module Jobs
    class Job
      def perform
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
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
