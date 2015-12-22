# encoding: utf-8
require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:votable) { create(:question) }

  describe 'PATCH #vote_up' do
    sign_in_user
    let(:vote_up) { patch :vote_up, votable_type: votable.class, votable_id: votable.id, format: :json }

    context 'non-author of votable votes' do
      it 'assigns requested votable to @votable' do
        vote_up

        expect(assigns(:votable)).to eq votable
      end

      it 'creates new vote with rating 1' do
        expect { vote_up }.to change(votable.votes, :count).by(1)
        expect(votable.votes.first.rating).to eq 1
      end

      it 'assigns current user to new vote' do
        vote_up

        expect(votable.votes.first.user.id).to eq @user.id
      end

      it 'render vote template' do
        vote_up

        expect(response).to render_template :vote
      end
    end

    context 'author of votable tries to vote' do
      let(:votable) { create(:question, user: @user) }

      it 'assigns requested votable to @votable' do
        vote_up

        expect(assigns(:votable)).to eq votable
      end

      it 'don`t changes votable.votes' do
        expect { vote_up }.to_not change(votable.votes, :count)
      end
    end
  end

  describe 'PATCH #vote_down' do
    sign_in_user
    let(:vote_down) { patch :vote_down, votable_type: votable.class, votable_id: votable.id, format: :json }


    context 'non-author of votable votes' do
      it 'assigns requested votable to @votable' do
        vote_down

        expect(assigns(:votable)).to eq votable
      end

      it 'creates new vote with rating -1' do
        expect { vote_down }.to change(votable.votes, :count).by(1)
        expect(votable.votes.first.rating).to eq -1
      end

      it 'assigns current user to new vote' do
        vote_down

        expect(votable.votes.first.user.id).to eq @user.id
      end

      it 'render vote template' do
        vote_down

        expect(response).to render_template :vote
      end
    end

    context 'author of votable tries to vote' do
      let(:votable) { create(:question, user: @user) }

      it 'assigns requested votable to @votable' do
        vote_down

        expect(assigns(:votable)).to eq votable
      end

      it 'don`t changes votable.votes' do
        expect { vote_down }.to_not change(votable.votes, :count)
      end
    end
  end

  describe 'PATCH #unvote' do
    sign_in_user
    let(:unvote) { patch :unvote, votable_type: votable.class, votable_id: votable.id, format: :json }

    context 'non-author of votable unvotes' do
      before { unvote }

      it 'assigns requested votable to @votable' do
        expect(assigns(:votable)).to eq votable
      end

      it 'deletes all user votable votes' do
        expect(votable.votes).to eq []
      end

      it 'render vote template' do
        expect(response).to render_template :vote
      end
    end

    context 'author of votable unvotes' do
      let(:votable) { create(:question, user: @user) }

      it 'assigns requested votable to @votable' do
        unvote

        expect(assigns(:votable)).to eq votable
      end

      it 'don`t changes votable.votes' do
        expect { unvote }.to_not change(votable.votes, :count)
      end
    end
  end
end
