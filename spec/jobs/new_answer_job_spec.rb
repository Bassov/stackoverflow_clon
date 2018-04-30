# frozen_string_literal: true

require "rails_helper"

RSpec.describe NewAnswerJob, type: :job do
  let!(:question) { create :question, user: user }
  let!(:user) { create :user }
  let!(:answer) { create :answer, question: question }

  it "use QuestionMailer to send emails" do
    expect(QuestionMailer).to receive(:new_answer).with(user, answer, question).and_call_original
    NewAnswerJob.perform_now(answer)
  end
end
