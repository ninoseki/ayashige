# frozen_string_literal: true

require "bundler/setup"

require 'coveralls'
Coveralls.wear!

require "ayashige"

require "vcr"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

require_relative "./support/helpers/io_helper"

RSpec.configure do |config|
  config.include Spec::Support::IOHelper
end

require_relative "./support/shared_contexts/job_context"
require_relative "./support/shared_examples/source_example"

RSpec.configure do |rspec|
  rspec.include_context "job context", include_shared: true
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.configure_rspec_metadata!
  config.hook_into :webmock
  config.ignore_localhost = true
end
