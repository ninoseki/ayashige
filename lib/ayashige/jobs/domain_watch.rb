# frozen_string_literal: true

module Ayashige
  module Jobs
    class DomainWatch < Job
      def initialize
        @source = Ayashige::Sources::DomainWatch.new
      end
    end
  end
end
