# frozen_string_literal: true

module Ayashige
  module Jobs
    class CT < Job
      def initialize
        @source = Ayashige::Sources::CT.new
      end
    end
  end
end
