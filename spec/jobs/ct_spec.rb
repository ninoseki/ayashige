# frozen_string_literal: true

RSpec.describe Ayashige::Jobs::CT, :vcr do
  include_context "job context"
  subject { Ayashige::Jobs::CT.new }
end
