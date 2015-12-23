# encoding: utf-8
require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :votes }
  it { should have_many :comments }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create :user }
  let(:user_question) { create :question, user: user }
  let(:question) { create :question }

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
    it 'changes votable.votes count' do
      expect { user.vote_for(question, 1) }.to change(question.votes.upvotes, :count).by(1)
    end

    it 'assigns passed rating(1) to new vote' do
      user.vote_for(question, 1)

      expect(question.votes.first.rating).to eq 1
    end

    it 'assigns passed rating(-1) to new vote' do
      user.vote_for(question, -1)

      expect(question.votes.first.rating).to eq -1
    end

    it 'prevents double votes' do
      user.vote_for(question, 1)
      user.vote_for(question, 1)

      expect(question.votes.size).to eq 1
    end
  end

  describe '#unvote_for' do
    it 'removes user vote from object' do
      user.vote_for(question, 1)
      expect { user.unvote_for(question) }.to change(question.votes, :count).by(-1)
    end
  end
end
