require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }

    let(:own_question) { create :question, user: user }
    let(:other_question) { create :question, user: other_user }
    let(:own_answer) { create :answer, user: user }
    let(:other_answer) { create :answer, user: other_user }


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }


    context 'Answer controller' do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, own_answer, user: user }
      it { should_not be_able_to :update, other_answer, user: user }

      it { should be_able_to :destroy, own_answer, user: user }
      it { should_not be_able_to :destroy, other_answer, user: user }

      it { should be_able_to :make_best, create(:answer, question: own_question), question: { user: user } }
      it { should_not be_able_to :make_best, create(:answer, question: other_question), question: { user: user } }
    end


    context 'Question controller' do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, own_question, user: user }
      it { should_not be_able_to :update, other_question, user: user }

      it { should be_able_to :destroy, own_question, user: user }
      it { should_not be_able_to :destroy, other_question, user: user }
    end

    # Comment controller
    it { should be_able_to :create, Comment }
  end
end