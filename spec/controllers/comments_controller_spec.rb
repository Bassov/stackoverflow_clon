# encoding: utf-8
require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:commentable) { create(:answer) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attribute' do
      subject { post :create, answer_id: commentable.id, comment: attributes_for(:comment), format: :js }
      let(:question_id) { commentable.question.id }

      it 'creates new comment' do
        expect { subject }.to change(commentable.comments, :count).by(1)
      end

      it 'renders create template' do
        subject

        expect(response).to render_template :create
      end

      it_behaves_like 'Publishable' do
        let(:channel) { "/questions/#{question_id}/comments" }
      end
    end

    context 'with invalid attributes' do
      subject { post :create, answer_id: commentable.id, comment: { body: '' }, format: :js }

      it 'do not creates new comment' do
        expect { subject }.to_not change(commentable.comments, :count)
      end

      it 'renders create template' do
        subject

        expect(response).to render_template :create
      end
    end
  end
end
