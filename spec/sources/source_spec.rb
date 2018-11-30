# frozen_string_literal: true

RSpec.describe Ayashige::Sources::Source, :vcr do
  subject { Ayashige::Sources::Source.new }

  describe "#normalize_date" do
    context "when given a valid date" do
      it "should return a %Y-%m-%d format string when given a valid date" do
        s = subject.send(:normalize_date, "2018/01/01")
        expect(s).to eq("2018-01-01")
      end
    end
    context "when given an invalid date" do
      it "should return a %Y-%m-%d format string when given a valid date" do
        expect { subject.send(:normalize_date, "invalid") }.to raise_error(ArgumentError)
      end
    end
  end
end
