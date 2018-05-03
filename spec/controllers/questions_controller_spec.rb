# encoding: utf-8
# frozen_string_literal: true

require "rails_helper"

RSpec.describe QuestionsController, type: :controller, integration: true do
  let(:questions) { create_list(:question, 2, user: user) }
  let(:question) { create(:question, user: user) }
  let(:user_question) { create(:question, user: @user) }
  let(:user) { create(:user) }

  describe "GET #index", positive: true do
    before { get :index }

    it "represents an array of all questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "renders index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show", positive: true do
    before { get :show, id: question }

    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "renders show view" do
      expect(response).to render_template :show
    end
  end

  describe "GET #new", positive: true do
    sign_in_user

    before { get :new }

    it "assigns a new Question to @question" do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it "renders new view" do
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    sign_in_user

    context "author of question edits it", positive: true do
      before { get :edit, id: user_question }

      it "assigns the requested question to @question" do
        expect(assigns(:question)).to eq user_question
      end

      it "renders new edit" do
        expect(response).to render_template :edit
      end
    end

    context "non-author tries to edit question", negative: true do
      before { get :edit, id: question }

      it "re-renders question view" do
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "POST #create" do
    sign_in_user

    context "with valid attributes", positive: true do
      subject { post :create, question: attributes_for(:question)  }

      it "saves the new question in the database" do
        expect { subject }.to change(Question, :count).by(1)
      end

      it "redirects to question view" do
        subject
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it_behaves_like "Publishable" do
        let(:channel) { "/questions" }
      end
    end

    context "with invalid attributes", negative: true do
      it "does not save the question" do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it "re-renders new view" do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    sign_in_user

    context "author of question updates question" do
      context "valid attributes", positive: true do
        it "assigns the requested question to @question" do
          patch :update, id: user_question, question: attributes_for(:question)
          expect(assigns(:question)).to eq user_question
        end

        it "change questions attributes" do
          patch :update, id: user_question, question: { title: "new title", body: "new body" }
          user_question.reload
          expect(user_question.title).to eq "new title"
          expect(user_question.body).to eq "new body"
        end

        it "redirects to the updated question" do
          patch :update, id: user_question, question: attributes_for(:question)
          expect(response).to redirect_to user_question
        end
      end

      context "invalid attributes", negative: true do
        before { patch :update, id: user_question, question: { title: "new title", body: nil } }

        it "does not change question attributes" do
          old_title = user_question.title
          old_body = user_question.body

          user_question.reload
          expect(user_question.title).to eq old_title
          expect(user_question.body).to eq old_body
        end

        it "re-renders edit template" do
          expect(response).to render_template :edit
        end
      end
    end

    context "non-author tries to update question", negative: true do
      before { patch :update, id: question, question: { title: "new title", body: "new body" } }

      it "does not change question attributes" do
        old_title = question.title
        old_body = question.body

        question.reload
        expect(question.title).to eq old_title
        expect(question.body).to eq old_body
      end

      it "re-renders question view" do
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "DELETE #destroy" do
    sign_in_user

    context "author of question deletes question", positive: true do
      it "deletes question" do
        user_question
        expect { delete :destroy, id: user_question }.to change(Question, :count).by(-1)
      end

      it "redirects to index view" do
        delete :destroy, id: user_question
        expect(response).to redirect_to questions_path
      end
    end

    context "non-author tries to delete question", negative: true do
      it "don`t deletes question" do
        question
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end

      it "redirects back" do
        delete :destroy, id: question
        expect(response).to redirect_to root_url
      end
    end
  end
end
