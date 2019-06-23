# frozen_string_literal: true

RSpec.shared_context "source context", shared_context: :metadata do
  let(:redis) { MockRedis.new }

  before do
    allow(Ayashige::Redis).to receive(:client).and_return(redis)
    allow(Parallel).to receive(:processor_count).and_return(0)
  end

  after do
    redis.flushdb
  end
end
