# frozen_string_literal: true

RSpec.shared_context "job context", shared_context: :metadata do
  describe "#perform" do
    context "when no error is raised" do
      before do
        mock = double
        allow(mock).to receive(:store_newly_registered_domains).and_return([])
        subject.instance_variable_set(:@source, mock)
      end

      it "returns the latest indexed date as a String" do
        output = capture(:stdout){ subject.perform }
        expect(output.empty?).to eq(true)
      end
    end

    context "when an error is raised" do
      before do
        mock = double
        allow(mock).to receive(:store_newly_registered_domains).and_raise(ArgumentError, "argument error")
        subject.instance_variable_set(:@source, mock)
      end

      it "returns the latest indexed date as a String" do
        output = capture(:stdout) { subject.perform }
        expect(output).to include("argument error")
      end
    end
  end
end
