# frozen_string_literal: true

require "yaml"

RSpec.describe Ayashige::Domain do
  subject { Ayashige::Domain }
  describe "#score" do
    let(:scores) { YAML.load_file File.expand_path("./fixtures/scores.yml", __dir__) }
    it "should calculate a suspicious score of a given domain" do
      domains = scores.keys
      domains.each do |domain|
        d = subject.new(domain)
        expect(d.score).to equal(scores[domain])
      end
    end
  end

  describe "#suspicious?" do
    context "when given an unofficial suspicious domain" do
      it "should return true" do
        d = subject.new("pay.pay.pay.pay.paypal.com.cn")
        expect(d.suspicious?).to eq(true)
      end
    end

    context "when given an suspicious but official domain" do
      it "should return false" do
        d = subject.new("pay.pay.pay.pay.paypal.com")
        expect(d.suspicious?).to eq(false)
      end
    end
  end
end
