# encoding: utf-8
require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:user_question) { create(:question, user: @user) }
  let(:user_answer) { create(:answer, question: question, user: @user) }
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
      before { @old_body = answer.body }
      before { patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js }

      it 'does not change question attributes' do
        answer.reload
        expect(answer.body).to eq @old_body
      end

      it 'renders update template' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #make_best' do
    sign_in_user
    let(:answer_user_question) { create(:answer, question: user_question, user: user) }

    context 'author of question sets answer to be best' do
      before { patch :make_best, id: answer_user_question, format: :js }

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer_user_question
      end

      it 'assigns the answer question to @question' do
        expect(assigns(:question)).to eq answer_user_question.question
      end

      it 'makes selected answer to be the best' do
        answer_user_question.reload
        expect(answer_user_question.best?).to be true
      end
    end

    context 'non-author of question sets answer to be best' do
      before { patch :make_best, id: answer, question_id: question, answer: { best: true }, format: :js }

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'don`t changes answers best option' do
        answer.reload
        expect(answer.best?).to be false
      end
    end
  end

  describe 'PATCH #vote_up' do
    sign_in_user
    before { patch :vote_up, id: answer }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'it creates new +1 vote from user' do
      expect(assigns(:answer).votes.first.rating).to eq 1
      expect(assigns(:answer).votes.first.user_id).to eq @user.id
    end

    it 'renders :vote_up template' do
      expect(response).to render_template :vote_up
    end
  end

  describe 'PATCH #vote_down' do
    sign_in_user
    before { patch :vote_down, id: answer }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'it creates new +1 vote from user' do
      expect(assigns(:answer).votes.first.rating).to eq -1
      expect(assigns(:answer).votes.first.user_id).to eq @user.id
    end

    it 'renders :vote_up template' do
      expect(response).to render_template :vote_down
    end
  end
end
