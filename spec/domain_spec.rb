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
end
