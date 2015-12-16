# encoding: utf-8
require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many :votes }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  it 'checks the authority of objects' do
    user = create(:user)
    object = create(:question, user: user)

    expect(user.author_of?(object)).to eq true
  end

  it 'checks the non-authority of objects' do
    user = create(:user)
    object = create(:question)

    expect(user.non_author_of?(object)).to eq true
  end
end
