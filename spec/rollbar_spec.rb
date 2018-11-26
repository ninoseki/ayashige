# frozen_string_literal: true

RSpec.describe Ayashige::Rollbar do
  subject { Ayashige::Rollbar }

  describe "#available?" do
    context "when ROLLBAR_ACCESS_TOKEN is set" do
      before do
        allow(ENV).to receive(:key?).with(subject::ROLLBAR_KEY).and_return(true)
      end

      it "should return true" do
        expect(subject.available?).to eq(true)
      end
    end

    context "when ROLLBAR_ACCESS_TOKEN is not set" do
      before do
        allow(ENV).to receive(:key?).with(subject::ROLLBAR_KEY).and_return(false)
      end

      it "should return false" do
        expect(subject.available?).to eq(false)
      end
    end
  end
end
