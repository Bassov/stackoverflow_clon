# encoding: utf-8
# frozen_string_literal: true

require "rails_helper"

RSpec.describe AttachmentsController, type: :controller, integration: true do
  let(:attachment) { create(:attachment, attachable: question) }
  let(:question) { create(:question, user: user) }
  let(:user_attachment) { create(:attachment, attachable: user_question) }
  let(:user_question) { create(:question, user: @user) }
  let(:user) { create(:user) }

  describe "DELETE #destroy" do
    sign_in_user

    context "Author of message deletes attachment", positive: true do
      before { @message = user_attachment.attachable }

      it "Assigns attachment to @attachment" do
        delete :destroy, id: user_attachment, format: :js

        expect(assigns(:attachment)).to eq user_attachment
      end

      it "Destroys attachment" do
        expect { delete :destroy, id: user_attachment, format: :js }.to change(@message.attachments, :count).by(-1)
      end

      it "Renders destroy template" do
        delete :destroy, id: user_attachment, format: :js

        expect(response).to render_template :destroy
      end
    end

    context "Non-author of message tries to delete it", negative: true do
      before { @message = attachment.attachable }

      it "Assigns attachment to @attachment" do
        delete :destroy, id: attachment, format: :js

        expect(assigns(:attachment)).to eq attachment
      end

      it "Don`t destroys attachment" do
        expect { delete :destroy, id: attachment, format: :js }.to_not change(@message.attachments, :count)
      end

      it "Returns 403 (forbidden) status" do
        delete :destroy, id: attachment, format: :js

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
