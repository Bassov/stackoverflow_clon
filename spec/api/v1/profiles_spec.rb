# frozen_string_literal: true

require "rails_helper"

describe "Profile API" do
  let(:me) { create :user }
  let(:access_token) { create :access_token, resource_owner_id: me.id }

  describe "GET /me" do
    it_behaves_like "API Authenticable"

    context "authorized", positive: true do
      before { get "/api/v1/profiles/me", format: :json, access_token: access_token.token }

      it_behaves_like "API #get response 200"

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/profiles/me", { format: :json }.merge(options)
    end
  end

  describe "GET /profiles" do
    it_behaves_like "API Authenticable"

    context "authorized", positive: true do
      let!(:users) { create_list(:user, 3) }

      before { get "/api/v1/profiles", format: :json, access_token: access_token.token }

      it_behaves_like "API #get response 200"

      it "returns list of users" do
        expect(response.body).to be_json_eql(users.to_json).at_path("users")
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path("users/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/profiles", { format: :json }.merge(options)
    end
  end
end
