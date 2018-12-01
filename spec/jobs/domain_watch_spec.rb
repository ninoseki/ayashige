# frozen_string_literal: true

RSpec.describe Ayashige::Jobs::DomainWatch, :vcr do
  include_context "job context"
  subject { Ayashige::Jobs::DomainWatch.new }
end
