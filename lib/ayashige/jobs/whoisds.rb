# frozen_string_literal: true

module Ayashige
  module Jobs
    class WhoisDS < Job
      def initialize
        @source = Ayashige::Sources::WhoisDS.new
      end

      def perform
        with_error_handling { @source.store_newly_registered_domains }
      end
    end
  end
end
