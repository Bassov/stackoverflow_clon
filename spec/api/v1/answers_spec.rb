require 'rails_helper'

describe 'Answers API' do
  let(:access_token) { create :access_token }

  describe 'GET /index' do
    let!(:question) { create :question }
    let!(:answers) { create_list(:answer, 2, question: question) }

    context 'unauthorized' do
      it 'returns 401 status if there no access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid ' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", question_id: question, format: :json,
                   access_token: access_token.token }

      it 'returns status 200' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:answer) { create :answer }
    let!(:comment) { create(:comment, commentable: answer) }
    let!(:attachment) { create(:attachment, attachable: answer) }

    context 'unauthorized' do
      it 'returns 401 status if there no access_token' do
        get "/api/v1/answers/#{answer.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid ' do
        get "/api/v1/answers/#{answer.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'returns status 200' do
        expect(response).to be_success
      end

      it 'returns required answer' do
        expect(response.body).to be_json_eql(answer.id.to_json).at_path('answer/id')
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('answer/attachments/0/file')
        end
      end
    end
  end

  describe 'POST /create' do
    let(:user) { create :user }
    let(:access_token) { create :access_token, resource_owner_id: user.id }
    let(:question) { create :question }

    context 'unauthorized' do
      it 'returns 401 status if there no access_token' do
        post "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid ' do
        post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      context 'invalid attributes' do
        let(:request) { post "/api/v1/questions/#{question.id}/answers", question_id: question,
                             answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token }

        it 'does not changes answers count' do
          expect { request }.to_not change(Answer, :count)
        end

        it 'returns status 422' do
          request
          expect(response.status).to eq 422
        end
      end

      context 'valid attributes' do
        let(:request) { post "/api/v1/questions/#{question.id}/answers", question_id: question,
                             answer: attributes_for(:answer), format: :json, access_token: access_token.token }

        it 'creates new answer for defined question' do
          expect { request }.to change(question.answers, :count).by(1)
        end

        it 'assigns resource_owner_id to user_id of answer' do
          expect { request }.to change(user.answers, :count).by(1)
        end

        it 'should be success status' do
          request
          expect(response).to have_http_status(:created)
        end
      end
    end
  end
end