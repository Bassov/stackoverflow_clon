# frozen_string_literal: true

require "rails_helper"

describe "Answers API" do
  let(:access_token) { create :access_token }

  describe "GET /index" do
    let!(:question) { create :question }

    it_behaves_like "API Authenticable"

    context "authorized" do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", question_id: question, format: :json,
                   access_token: access_token.token }

      it_behaves_like "API #get response 200"

      it "returns list of answers" do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe "GET /show" do
    let!(:answer) { create :answer }

    it_behaves_like "API Authenticable"

    context "authorized" do
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:attachment) { create(:attachment, attachable: answer) }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it_behaves_like "API #get response 200"

      it "returns required answer" do
        expect(response.body).to be_json_eql(answer.id.to_json).at_path("answer/id")
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context "comments" do
        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context "attachments" do
        it "contains url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/file")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe "POST /create" do
    let(:user) { create :user }
    let(:access_token) { create :access_token, resource_owner_id: user.id }
    let(:question) { create :question }

    it_behaves_like "API Authenticable"

    context "authorized" do
      context "invalid attributes" do
        let(:request) { post "/api/v1/questions/#{question.id}/answers", question_id: question,
                             answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token }

        it "does not changes answers count" do
          expect { request }.to_not change(Answer, :count)
        end

        it "returns status 422" do
          request
          expect(response.status).to eq 422
        end
      end

      context "valid attributes" do
        let(:request) { post "/api/v1/questions/#{question.id}/answers", question_id: question,
                             answer: attributes_for(:answer), format: :json, access_token: access_token.token }

        it "creates new answer for defined question" do
          expect { request }.to change(question.answers, :count).by(1)
        end

        it "assigns resource_owner_id to user_id of answer" do
          expect { request }.to change(user.answers, :count).by(1)
        end

        it "should be success status" do
          request
          expect(response).to have_http_status(:created)
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end
end
