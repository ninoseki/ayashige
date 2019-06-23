# frozen_string_literal: true

RSpec.describe Ayashige::Jobs::Job do
  subject { described_class.new }

  describe "#perform" do
    context "when an error is raised in #perform" do
      before do
        source = double("source")
        allow(source).to receive(:store_newly_registered_domains).and_raise(ArgumentError)
        subject.instance_variable_set(:@source, source)
      end

      context "when Rollbar is enabled" do
        before do
          allow(Ayashige::Rollbar).to receive(:available?).and_return(true)
          allow(Ayashige::Rollbar).to receive(:error).and_return(nil)
        end

        it "does not raise any error" do
          out = capture(:stdout) { expect { subject.perform }.not_to raise_error }
          expect(out.empty?).to eq(true)
        end
      end

      context "when Rollbar is disabled" do
        before do
          allow(Ayashige::Rollbar).to receive(:available?).and_return(false)
        end

        it "does not raise any error" do
          out = capture(:stdout) { expect { subject.perform }.not_to raise_error }
          expect(out.chomp).to eq("ArgumentError")
        end
      end
    end
  end
end
