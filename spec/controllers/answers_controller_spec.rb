require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #new' do
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
    context 'with valid attribute' do
      it 'creates new answer' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer)
        }.to change(question.answers, :count).by 1
      end

      it 'redirect to question/show view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'don`t creates new answer`' do
      it 'does not save the question' do
        expect {
          post :create, question_id: question, answer: attributes_for(:invalid_answer)
        }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
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
