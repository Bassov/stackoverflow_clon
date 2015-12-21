# encoding: utf-8
require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many :votes }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  let(:user) { create(:user) }
  let(:user_question) { create(:question, user: user) }
  let(:question) { create(:question) }

  describe '#author_of?' do
    it 'checks the authority of objects' do
      expect(user.author_of?(user_question)).to eq true
    end
  end

  describe '#non_author_of?' do
    it 'checks the non-authority of objects' do
      expect(user.non_author_of?(question)).to eq true
    end
  end

  describe '#vote_for' do
    it 'vote with rating 1' do
      expect{ user.vote_for(question, 1) }.to change(question.votes.upvotes, :count).by(1)
    end

    it 'vote with rating -1' do
      expect{ user.vote_for(question, -1) }.to change(question.votes.downvotes, :count).by(1)
    end
  end

  describe '#unvote_for' do
    it 'removes user vote from object' do
      user.vote_for(question, 1)
      expect{ user.unvote_for(question) }.to change(question.votes, :count).by(-1)
    end
  end
end
