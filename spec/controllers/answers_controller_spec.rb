require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

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

      it 're-renders create view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :create
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
