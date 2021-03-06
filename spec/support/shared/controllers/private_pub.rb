# frozen_string_literal: true

shared_examples_for "Publishable" do
  it "should publish after creating", positive: true do
    expect(PrivatePub).to receive(:publish_to).with(channel, kind_of(Hash))
    subject
  end
end
