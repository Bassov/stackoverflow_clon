# encoding: utf-8
require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:user) { create(:user) }

  describe 'GET #new' do
    sign_in_user

    it 'sets question.answers.new to @answer' do
      get :new, question_id: question
      expect(assigns(:answer)).to be_a_new Answer
      expect(assigns(:answer).question).to eq question
    end
    it 'render new view'do
      get :new, question_id: question
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attribute' do
      it 'creates new answer' do
        expect do
          post :create, question_id: question, answer: attributes_for(:answer)
        end.to change(question.answers, :count).by 1
      end

      it 'redirect to question/show view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'don`t creates new answer`' do
      it 'does not save the question' do
        expect do
          post :create, question_id: question, answer: attributes_for(:invalid_answer)
        end.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    it 'deletes answer' do
      answer
      expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, id: answer
      expect(response).to redirect_to question_path(question)
    end
  end
end
