# frozen_string_literal: true

module Ayashige
  module Jobs
    class SecurityTrails < Job
      def initialize
        @source = Ayashige::Sources::SecurityTrails.new
      end
    end
  end
end
