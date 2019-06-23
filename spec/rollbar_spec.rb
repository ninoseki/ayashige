# frozen_string_literal: true

RSpec.describe Ayashige::Rollbar do
  subject { described_class }

  describe "#available?" do
    context "when ENV['ROLLBAR_ACCESS_TOKEN'] exists" do
      before do
        allow(ENV).to receive(:key?).with(subject::ROLLBAR_KEY).and_return(true)
      end

      it "returns true" do
        expect(subject.available?).to eq(true)
      end
    end

    context "when ENV['ROLLBAR_ACCESS_TOKEN'] not exists" do
      before do
        allow(ENV).to receive(:key?).with(subject::ROLLBAR_KEY).and_return(false)
      end

      it "returns false" do
        expect(subject.available?).to eq(false)
      end
    end
  end
end
