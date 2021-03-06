# encoding: utf-8
# frozen_string_literal: true

require "rails_helper"

RSpec.describe Answer, type: :model, unit: true, positive: true do
  it_behaves_like "Attachable"

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should have_many(:votes) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:question_id) }
  it { should validate_presence_of(:user_id) }

  describe "default_scope" do
    let(:question) { create(:question) }
    let(:best_answer) { create(:answer, question: question) }

    it "shows best answer first" do
      best_answer.make_best
      expect(question.answers.first).to eq best_answer
    end
  end

  describe "make_best response true" do
    subject { create :answer }
    let(:answers) { create_list(:answer, 3) }

    it "sets #best to true" do
      subject.make_best
      expect(subject.best?).to be true
    end

    it "sets #best to all other answers to false" do
      answers.first.make_best
      answers.shift
      answers.each do |answer|
        expect(answer.best?).to be false
      end
    end
  end

  describe "after_create#send_notification" do
    subject { build(:answer) }

    it "sends method to answer after create" do
      expect(subject).to receive(:send_notification)
      subject.save!
    end

    it "peforms job" do
      expect(NewAnswerJob).to receive(:perform_later).with(subject)
      subject.save!
    end
  end
end
