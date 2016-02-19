# encoding: utf-8
require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:votable) { create(:question) }

  describe 'PATCH #create_vote' do
    sign_in_user
    let(:vote) { patch :create_vote, votable_type: votable.class, votable_id: votable.id, rating: 1, format: :json }

    context 'non-author of votable votes' do
      it 'assigns requested votable to @votable' do
        vote

        expect(assigns(:votable)).to eq votable
      end

      it 'creates new vote with rating 1' do
        expect { vote }.to change(votable.votes, :count).by(1)
        expect(votable.votes.first.rating).to eq 1
      end

      it 'assigns current user to new vote' do
        vote

        expect(votable.votes.first.user.id).to eq @user.id
      end

      it 'render create_vote template' do
        vote

        expect(response).to render_template :create_vote
      end
    end

    context 'author of votable tries to create_vote' do
      let(:votable) { create(:question, user: @user) }

      it 'assigns requested votable to @votable' do
        vote

        expect(assigns(:votable)).to eq votable
      end

      it 'don`t changes votable.votes' do
        expect { vote }.to_not change(votable.votes, :count)
      end
    end

    context 'non-author votes second time' do
      it 'assigns requested votable to @votable' do
        vote

        expect(assigns(:votable)).to eq votable
      end

      it 'unvote for votable' do
        expect { vote }.to change(votable.votes, :count).by(1)
      end

      it 'render create_vote template' do
        vote

        expect(response).to render_template :create_vote
      end
    end
  end
end
