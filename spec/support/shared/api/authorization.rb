# frozen_string_literal: true

shared_examples_for "API Authenticable" do
  context "unauthorized", negative: true do
    it "should returns 401 status if there is no access_token" do
      do_request
      expect(response.status).to eq 401
    end

    it "should returns 401 status if access_token is invalid" do
      do_request(access_token: "123123")
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for "API #get response 200" do
  it "returns status 200", positive: true do
    expect(response).to be_success
  end
end
