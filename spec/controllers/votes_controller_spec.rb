require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:votable) { create(:question, user: user) }

  describe 'PATCH #vote_up' do
    sign_in_user

    it 'assigns requested votable to @votable' do
      patch :vote_up, votable_type: votable.class, votable_id: votable.id, format: :json

      expect(assigns(:votable)).to eq votable
    end

    it 'creates new vote with rating 1' do
      expect { patch :vote_up, votable_type: votable.class, votable_id: votable.id, format: :json }.to change(votable.votes, :count).by(1)
      expect(votable.votes.first.rating).to eq 1
    end

    it 'assigns current user to new vote' do
      patch :vote_up, votable_type: votable.class, votable_id: votable.id, format: :json

      expect(votable.votes.first.user.id).to eq @user.id
    end
  end

  describe 'PATCH #vote_down' do
    sign_in_user

    it 'assigns requested votable to @votable' do
      patch :vote_down, votable_type: votable.class, votable_id: votable.id, format: :json

      expect(assigns(:votable)).to eq votable
    end

    it 'creates new vote with rating -1' do
      expect { patch :vote_down, votable_type: votable.class, votable_id: votable.id, format: :json }.to change(votable.votes, :count).by(1)
      expect(votable.votes.first.rating).to eq -1
    end

    it 'assigns current user to new vote' do
      patch :vote_down, votable_type: votable.class, votable_id: votable.id, format: :json

      expect(votable.votes.first.user.id).to eq @user.id
    end
  end

  describe 'PATCH #unvote' do
    sign_in_user

    before { patch :unvote, votable_type: votable.class, votable_id: votable.id, format: :json }

    it 'assigns requested votable to @votable' do
      expect(assigns(:votable)).to eq votable
    end

    it 'deletes all user votable votes' do
      expect(votable.votes).to eq []
    end
  end
end
