# encoding: utf-8
# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model, unit: true do
  context "associations", positive: true do
    it { should have_many :questions }
    it { should have_many :answers }
    it { should have_many :votes }
    it { should have_many :comments }
    it { should have_many :authorizations }

    it { should have_many(:subscriptions).dependent(:destroy) }
    it { should have_many(:subscribes).through(:subscriptions).source(:question) }

    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  let(:user) { create :user }
  let(:user_question) { create :question, user: user }
  let(:question) { create :question }

  describe "#vote_for" do
    it "changes votable.votes count", positive: true do
      expect { user.vote_for(question, 1) }.to change(question.votes.upvotes, :count).by(1)
    end

    it "assigns passed rating(1) to new create", positive: true do
      user.vote_for(question, 1)

      expect(question.votes.first.rating).to eq 1
    end

    it "assigns passed rating(-1) to new create", positive: true do
      user.vote_for(question, -1)

      expect(question.votes.first.rating).to eq -1
    end

    it "prevents double votes", negative: true do
      user.vote_for(question, 1)
      user.vote_for(question, 1)

      expect(question.votes.size).to eq 1
    end
  end

  describe "#unvote_for" do
    it "removes user create from object", negative: true do
      user.vote_for(question, 1)
      expect { user.unvote_for(question) }.to change(question.votes, :count).by(-1)
    end
  end

  describe ".find_for_oauth" do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456") }

    context "user already has authorization", positive: true do
      it "returns the user" do
        user.authorizations.create(provider: "facebook", uid: "123456")
        expect(described_class.find_for_oauth(auth)).to eq user
      end
    end

    context "provider gives invalid hash", negative: true do
      context "no uid" do
        let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "") }

        it "does not creates user" do
          expect { described_class.find_for_oauth(auth) }.to_not change(described_class, :count)
        end

        it "returns nil" do
          expect(described_class.find_for_oauth(auth)).to be_nil
        end
      end

      context "no provider" do
        let(:auth) { OmniAuth::AuthHash.new(provider: "", uid: "123456") }

        it "does not creates user" do
          expect { described_class.find_for_oauth(auth) }.to_not change(described_class, :count)
        end

        it "returns nil" do
          expect(described_class.find_for_oauth(auth)).to be_nil
        end
      end
    end

    context "user has not authorization" do
      context "user already exists", negative: true do
        let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456", info: { email: user.email }) }
        it "does not create new user" do
          expect { described_class.find_for_oauth(auth) }.to_not change(described_class, :count)
        end

        it "creates authorization for user" do
          expect { described_class.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it "creates authorization with provider and uid" do
          authorization = described_class.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it "returns the user" do
          expect(described_class.find_for_oauth(auth)).to eq user
        end
      end

      context "user does not exist", positive: true do

        context "provider gives email" do
          let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456", info: { email: "new@user.com" }) }

          it "creates new user" do
            expect { described_class.find_for_oauth(auth) }.to change(described_class, :count).by(1)
          end

          it "returns new user" do
            expect(described_class.find_for_oauth(auth)).to be_a(described_class)
          end

          it "fills user email" do
            user = described_class.find_for_oauth(auth)
            expect(user.email).to eq auth.info[:email]
          end

          it "creates authorization for user" do
            user = described_class.find_for_oauth(auth)
            expect(user.authorizations).to_not be_empty
          end

          it "creates authorization with provider and uid" do
            authorization = described_class.find_for_oauth(auth).authorizations.first

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end
        end

        context "provider does not gives email", negative: true do
          let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456") }

          it "creates new user" do
            expect { described_class.find_for_oauth(auth) }.to change(described_class, :count).by(1)
          end

          it "returns new user" do
            expect(described_class.find_for_oauth(auth)).to be_a(described_class)
          end

          it "generates user email" do
            user = described_class.find_for_oauth(auth)
            expect(user.email).to eq "#{user.id}@stackoverflow_clon.com"
          end

          it "creates authorization for user" do
            user = described_class.find_for_oauth(auth)
            expect(user.authorizations).to_not be_empty
          end

          it "creates authorization with provider and uid" do
            authorization = described_class.find_for_oauth(auth).authorizations.first

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end
        end
      end
    end
  end
end
