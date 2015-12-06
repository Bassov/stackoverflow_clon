# encoding: utf-8
require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:question_id) }
  it { should validate_presence_of(:user_id) }

  describe 'default_scope' do
    let(:question) { create(:question) }
    let(:best_answer) { create(:answer, question: question) }

    it 'shows best answer first' do
      best_answer.make_best
      expect(question.answers.first).to eq best_answer
    end
  end

  describe 'make_best response true' do

    let(:answer) { create(:answer) }

    it 'sets #best to true' do
      answer.make_best
      expect(answer.best?).to be true
    end

    let(:answers) { create_list(:answer, 3) }

    it 'sets #best to all other answers to false' do
      answers.first.make_best
      answers.shift
      answers.each do |answer|
        expect(answer.best?).to be false
      end
    end
  end
end
