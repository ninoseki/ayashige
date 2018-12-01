# frozen_string_literal: true

RSpec.describe Ayashige::Jobs::WhoisDS, :vcr do
  include_context "job context"
  subject { Ayashige::Jobs::WhoisDS.new }
end
