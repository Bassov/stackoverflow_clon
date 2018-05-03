# frozen_string_literal: true

require "rails_helper"

RSpec.describe Subscription, type: :model, unit: true, positive: true do
  it { should belong_to :user }
  it { should belong_to :question }
end
