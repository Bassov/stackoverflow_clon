# encoding: utf-8
# frozen_string_literal: true

require "rails_helper"

RSpec.describe Attachment, type: :model, unit: true, positive: true do
  it { should belong_to :attachable }
end
