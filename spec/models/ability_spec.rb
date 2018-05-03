# frozen_string_literal: true

require "rails_helper"

describe Ability, unit: true do
  subject(:ability) { Ability.new(user) }

  describe "for guest" do
    let(:user) { nil }

    context "able", positive: true do
      it { should be_able_to :read, Question }
      it { should be_able_to :read, Answer }
      it { should be_able_to :read, Comment }
    end

    context "not able", negative: true do
      it { should_not be_able_to :manage, :all }
    end
  end

  describe "for admin", positive: true do
    let(:user) { create :user, admin: true }

    context "able", positive: true do
      it { should be_able_to :manage, :all }
    end
  end

  describe "for user" do
    let(:user) { create :user }
    let(:other_user) { create :user }

    let(:own_question) { create :question, user: user }
    let(:other_question) { create :question, user: other_user }

    let(:own_answer) { create :answer, user: user }
    let(:other_answer) { create :answer, user: other_user }

    context "not able", negative: true do
      it { should_not be_able_to :manage, :all }
    end

    context "able", positive: true do
      it { should be_able_to :read, :all }
    end


    context "Answer controller" do
      context "able", positive: true do
        it { should be_able_to :create, Answer }
        it { should be_able_to :update, own_answer, user: user }
        it { should be_able_to :destroy, own_answer, user: user }
        it { should be_able_to :make_best, create(:answer, question: own_question), question: { user: user } }
      end

      context "not able", negative: true do
        it { should_not be_able_to :update, other_answer, user: user }
        it { should_not be_able_to :destroy, other_answer, user: user }
        it { should_not be_able_to :make_best, create(:answer, question: other_question), question: { user: user } }
      end
    end


    context "Question controller" do
      context "able", positive: true do
        it { should be_able_to :create, Question }
        it { should be_able_to :update, own_question, user: user }
        it { should be_able_to :destroy, own_question, user: user }
      end

      context "not able", negative: true do
        it { should_not be_able_to :update, other_question, user: user }
        it { should_not be_able_to :destroy, other_question, user: user }
      end
    end

    context "Attachments controller" do
      let(:own_attachment) { create :attachment, attachable: own_question }
      let(:other_attachment) { create :attachment, attachable: other_question }

      context "able", positive: true do
        it { should be_able_to :destroy, own_attachment, attachable: { user: user } }
      end

      context "not able", negative: true do
        it { should_not be_able_to :destroy, other_attachment, attachable: { user: user } }
      end
    end

    context "Comments controller" do
      context "able", positive: true do
        it { should be_able_to :create, Comment }
      end
    end

    context "Votes controller" do
      context "able", positive: true do
        it { should be_able_to :create_vote, other_answer, user: user }
        it { should be_able_to :create_vote, other_question, user: user }
      end

      context "not able", negative: true do
        it { should_not be_able_to :create_vote, own_question, user: user }
        it { should_not be_able_to :create_vote, own_answer, user: user }
      end
    end

    context "Subscriptions controller" do
      let(:question) { create :question }
      let(:own_subscription) { create :subscription, user: user, question: question }
      let(:other_subscription) { create :subscription, user: other_user, question: question }

      context "able", positive: true do
        it { should be_able_to :create, Subscription }
        it { should be_able_to :destroy, own_subscription, user: user }
      end

      context "not able", negative: true do
        it { should_not be_able_to :destroy, other_subscription, user: user }
      end
    end

    context "api/v1/profiles controller" do
      context "able", positive: true do
        it { should be_able_to :me, user, user: user }
      end

      context "not able", negative: true do
        it { should_not be_able_to :me, other_user, user: user }
      end
    end
  end
end
