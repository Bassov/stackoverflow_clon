# encoding: utf-8
# frozen_string_literal: true

require "rails_helper"

RSpec.describe Question, type: :model do
  it_behaves_like "Attachable"

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many :votes }
  it { should have_many(:comments).dependent(:destroy) }

  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscriptions).source(:user) }

  it { should belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  describe "#subscribe" do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }

    context "not subscribed user" do
      it "should create subscription" do
        expect { question.subscribe(user) }.to change(question.subscribers, :count).by(1)
      end
    end

    context "already subscribed user" do
      it "should not create Subscription" do
        question.subscribers << user

        expect { question.subscribe(user) }.to_not change(Subscription, :count)
      end
    end
  end

  describe "#unsubscribe" do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }

    context "already subscribed user" do
      it "should destroy subscription" do
        question.subscribers << user

        expect { question.unsubscribe(user) }.to change(question.subscribers, :count).by(-1)
      end
    end

    context "non subscribed user" do
      it "should not change subscription count" do
        expect { question.unsubscribe(user) }.to_not change(Subscription, :count)
      end
    end
  end

  describe "after_create#subscribe_author" do
    let(:user) { create :user }
    subject { build(:question, user: user) }

    it "sends method to question after create" do
      expect(subject).to receive(:subscribe_author)
      subject.save!
    end

    it "subscribes author of question to question" do
      expect { subject.save! }.to change(user.subscribes, :count).by(1)
    end

  end
end
