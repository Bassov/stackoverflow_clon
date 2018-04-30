# encoding: utf-8
# frozen_string_literal: true

require "rails_helper"

RSpec.describe Vote, type: :model do
  it { should validate_presence_of :user_id }
  it { should validate_uniqueness_of(:user_id).scoped_to([:votable_type, :votable_id]) }

  it { should belong_to :votable }
  it { should belong_to :user }
end
