# encoding: utf-8
require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question, user: user) }
  let(:user_answer) { create(:answer, question: question, user: @user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attribute' do
      it 'creates new answer' do
        expect do
          post :create, question_id: question, answer: attributes_for(:answer), format: :js
        end.to change(question.answers, :count).by 1
      end

      it 'renders create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        end.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'author of answer deletes answer' do
      it 'deletes answer' do
        user_answer
        expect { delete :destroy, id: user_answer, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirects to render render template destroy' do
        delete :destroy, id: user_answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'non-author of answer tries to delete it' do
      it 'does not delete answer' do
        answer
        expect { delete :destroy, id: answer, format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'author of answer updates answer' do
      it 'assigns the requested answer to @answer' do
        patch :update, id: user_answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq user_answer
      end

      it 'assigns the question' do
        patch :update, id: user_answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'change answer attributes' do
        patch :update, id: user_answer, question_id: question, answer: { body: 'New body' }, format: :js
        user_answer.reload
        expect(user_answer.body).to eq 'New body'
      end

      it 'renders update template' do
        patch :update, id: user_answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end

    context 'non-author tries to update question' do
      before { patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js }

      it 'does not change question attributes' do
        old_body = answer.body

        answer.reload
        expect(answer.body).to eq old_body
      end

      it 'renders update template' do
        expect(response).to render_template :update
      end
    end
  end
end
