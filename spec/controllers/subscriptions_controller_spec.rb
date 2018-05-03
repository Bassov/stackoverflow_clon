# frozen_string_literal: true

require "rails_helper"

RSpec.describe SubscriptionsController, type: :controller, integration: true do
  let(:user) { create :user }
  let(:question) { create :question }

  describe "POST #create" do
    sign_in_user

    context "with valid attribute", positive: true do
      subject { post :create, question_id: question.id, format: :js }

      it "creates new answer" do
        expect { subject }.to change(question.subscribers, :count).by 1
      end

      it "renders create template" do
        subject
        expect(response).to render_template :create
      end
    end
  end

  describe "DELETE #destroy" do
    sign_in_user

    context "subscriber deletes own subscription", positive: true do
      subject { delete :destroy, question_id: question.id, format: :js }
      before { post :create, question_id: question.id, format: :js }

      it "deletes subscription" do
        expect { subject }.to change(question.subscribers, :count).by(-1)
      end

      it "renders create template" do
        subject
        expect(response).to render_template :destroy
      end
    end
  end
end
