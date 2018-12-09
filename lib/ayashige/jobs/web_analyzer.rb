# frozen_string_literal: true

module Ayashige
  module Jobs
    class WebAnalyzer < Job
      def initialize
        @source = Ayashige::Sources::WebAnalyzer.new
      end
    end
  end
end
