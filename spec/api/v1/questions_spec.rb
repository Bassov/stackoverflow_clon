# frozen_string_literal: true

require "rails_helper"

describe "Questions API", integration: true do
  let(:access_token) { create :access_token }

  describe "GET /index" do
    it_behaves_like "API Authenticable"

    context "authorized", positive: true do
      let!(:questions) { create_list(:question, 2) }
      let(:question)  { questions.first }
      let!(:answer) { create :answer, question: question }

      before { get "/api/v1/questions", format: :json, access_token: access_token.token }

      it_behaves_like "API #get response 200"

      it "returns list of questions" do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      context "answers" do
        it "included in question object" do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions", { format: :json }.merge(options)
    end
  end

  describe "GET /show" do
    let!(:question) { create(:question) }

    it_behaves_like "API Authenticable"

    context "authorized", positive: true do
      let!(:answer) { create(:answer, question: question) }
      let!(:comment) { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachable: question) }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it_behaves_like "API #get response 200"

      it "returns required question" do
        expect(response.body).to be_json_eql(question.id.to_json).at_path("question/id")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context "comments" do
        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context "attachment" do
        it "contains url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/file")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe "POST /create" do
    let(:user) { create :user }
    let(:access_token) { create :access_token, resource_owner_id: user.id }

    it_behaves_like "API Authenticable"

    context "authorized" do
      context "invalid attributes", negative: true do
        let(:request) { post "/api/v1/questions", question: attributes_for(:invalid_question),
                             format: :json, access_token: access_token.token }

        it "does not changes questions count" do
          expect { request }.to_not change(Question, :count)
        end

        it "returns 422 status" do
          request
          expect(response.status).to eq 422
        end
      end

      context "valid attributes", positive: true do
        let(:request) { post "/api/v1/questions", question: attributes_for(:question),
                             format: :json, access_token: access_token.token }

        it "create new question" do
          expect { request }.to change(user.questions, :count).by(1)
        end

        it "should be success status" do
          request
          expect(response).to have_http_status(:created)
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions", { format: :json }.merge(options)
    end
  end
end
