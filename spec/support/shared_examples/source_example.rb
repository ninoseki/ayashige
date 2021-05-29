# frozen_string_literal: true

RSpec.shared_examples "#store_newly_registered_domains example" do
  let(:updated_on) { "2018-01-01" }
  let(:domain_name) { "paypal.pay.pay.world" }
  let(:record) { Ayashige::Record.new(updated: updated_on, domain_name: "paypal.pay.pay.world") }
  let(:records) { [record] }

  it "stores parsed domains into Redis" do
    output = capture(:stdout) { subject.store_newly_registered_domains }
    expect(output.include?(domain_name)).to eq(true)
    expect(redis.exists(domain_name)).to eq(1)
  end
end
