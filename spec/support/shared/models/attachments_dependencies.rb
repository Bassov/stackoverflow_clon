# frozen_string_literal: true

shared_examples_for "Attachable" do
  context "associations", unit: true, positive: true do
    it { should have_many(:attachments).dependent(:destroy) }
    it { should accept_nested_attributes_for(:attachments) }
  end
end
