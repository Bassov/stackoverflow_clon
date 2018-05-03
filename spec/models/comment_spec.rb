# encoding: utf-8
# frozen_string_literal: true

require "rails_helper"

RSpec.describe Comment, type: :model, unit: true, positive: true do
  it { should belong_to :commentable }
  it { should belong_to :user }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :body }
end
