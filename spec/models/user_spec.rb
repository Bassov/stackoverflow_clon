# encoding: utf-8
require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :votes }
  it { should have_many :comments }
  it { should have_many :authorizations }

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

    it 'assigns passed rating(1) to new create' do
      user.vote_for(question, 1)

      expect(question.votes.first.rating).to eq 1
    end

    it 'assigns passed rating(-1) to new create' do
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
    it 'removes user create from object' do
      user.vote_for(question, 1)
      expect { user.unvote_for(question) }.to change(question.votes, :count).by(-1)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(described_class.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect { described_class.find_for_oauth(auth) }.to_not change(described_class, :count)
        end

        it 'creates authorization for user' do
          expect { described_class.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = described_class.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(described_class.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { described_class.find_for_oauth(auth) }.to change(described_class, :count).by(1)
        end

        it 'returns new user' do
          expect(described_class.find_for_oauth(auth)).to be_a(described_class)
        end

        it 'fills user email' do
          user = described_class.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          user = described_class.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = described_class.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
