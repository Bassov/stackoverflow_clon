# encoding: utf-8
# frozen_string_literal: true

require "rails_helper"

RSpec.describe AnswersController, type: :controller, integration: true do
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:user_question) { create(:question, user: @user) }
  let(:user_answer) { create(:answer, question: question, user: @user) }
  let(:user) { create(:user) }

  describe "POST #create" do
    sign_in_user

    context "with valid attribute", positive: true do
      subject { post :create, question_id: question, answer: attributes_for(:answer), format: :js }

      it "creates new answer" do
        expect { subject }.to change(question.answers, :count).by 1
      end

      it "renders create template" do
        subject
        expect(response).to render_template :create
      end

      it_behaves_like "Publishable" do
        let(:channel) { "/questions/#{question.id}/answers" }
      end
    end

    context "with invalid attributes", negative: true do
      subject { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }

      it "does not save the question" do
        expect { subject }.to_not change(Answer, :count)
      end

      it "renders create template" do
        subject
        expect(response).to render_template :create
      end
    end
  end

  describe "DELETE #destroy" do
    sign_in_user

    context "author of answer deletes answer", positive: true do
      it "deletes answer" do
        user_answer
        expect { delete :destroy, id: user_answer, format: :js }.to change(Answer, :count).by(-1)
      end

      it "redirects to render render template destroy" do
        delete :destroy, id: user_answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "non-author of answer tries to delete it", negative: true do
      it "does not delete answer" do
        answer
        expect { delete :destroy, id: answer, format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe "PATCH #update" do
    sign_in_user

    context "author of answer updates answer", positive: true do
      it "assigns the requested answer to @answer" do
        patch :update, id: user_answer, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq user_answer
      end

      it "change answer attributes" do
        patch :update, id: user_answer, answer: { body: "New body" }, format: :js
        user_answer.reload
        expect(user_answer.body).to eq "New body"
      end

      it "renders update template" do
        patch :update, id: user_answer, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end

    context "non-author tries to update question", negative: true do
      before { @old_body = answer.body }
      before { patch :update, id: answer, answer: attributes_for(:answer), format: :js }

      it "does not change question attributes" do
        answer.reload
        expect(answer.body).to eq @old_body
      end

      it "returns 403 (forbidden) status" do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PATCH #make_best" do
    sign_in_user
    let(:answer_user_question) { create(:answer, question: user_question, user: user) }

    context "author of question sets answer to be best", positive: true do
      before { patch :make_best, id: answer_user_question, format: :js }

      it "assigns the requested answer to @answer" do
        expect(assigns(:answer)).to eq answer_user_question
      end

      it "makes selected answer to be the best" do
        answer_user_question.reload
        expect(answer_user_question.best?).to be true
      end
    end

    context "non-author of question sets answer to be best", negative: true do
      before { patch :make_best, id: answer, format: :js }

      it "assigns the requested answer to @answer" do
        expect(assigns(:answer)).to eq answer
      end

      it "don`t changes answers best option" do
        answer.reload
        expect(answer.best?).to be false
      end
    end
  end
end
