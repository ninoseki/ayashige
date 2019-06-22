# frozen_string_literal: true

RSpec.describe Ayashige::Jobs::SecurityTrails, :vcr do
  include_context "job context"
  subject { Ayashige::Jobs::SecurityTrails.new }
end
