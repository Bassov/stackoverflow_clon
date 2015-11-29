# encoding: utf-8
require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question, user: user) }
  let(:user_answer) { create(:answer, question: question, user: @user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:user) { create(:user) }
  before { request.env['HTTP_REFERER'] = 'where_i_came_from' }

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

    context 'don`t creates new answer`' do
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
        expect { delete :destroy, id: user_answer }.to change(Answer, :count).by(-1)
      end

      it 'redirects to render question view' do
        delete :destroy, id: user_answer
        expect(response).to redirect_to 'where_i_came_from'
      end
    end

    context 'non-author of answer tries to delete it' do
      it 'does not delete answer' do
        answer
        expect { delete :destroy, id: answer }.to_not change(Answer, :count)
      end
    end
  end
end
