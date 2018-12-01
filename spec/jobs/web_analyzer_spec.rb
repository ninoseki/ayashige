# frozen_string_literal: true

RSpec.describe Ayashige::Jobs::WebAnalyzer, :vcr do
  include_context "job context"
  subject { Ayashige::Jobs::WebAnalyzer.new }
end
