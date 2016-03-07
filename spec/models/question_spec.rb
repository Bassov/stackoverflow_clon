# encoding: utf-8
require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'Attachable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many :votes }
  it { should have_many(:comments).dependent(:destroy) }

  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscriptions).source(:user) }

  it { should belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
end
