require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:commentable) { create(:answer) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attribute' do
      let(:create_comment) { post :create, answer_id: commentable.id, comment: attributes_for(:comment), format: :js }

      it 'creates new comment' do
        expect { create_comment }.to change(commentable.comments, :count).by(1)
      end

      it 'renders create template' do
        create_comment

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      # it 'does not save the question' do
      #   expect do
      #     post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
      #   end.to_not change(Answer, :count)
      # end
      #
      # it 'renders create template' do
      #   post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
      #   expect(response).to render_template :create
      # end
    end
  end
end
