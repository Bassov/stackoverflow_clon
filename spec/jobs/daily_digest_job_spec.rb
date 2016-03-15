require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:question) { create :question, user: users.first }
  let!(:users) { create_list :user, 2 }

  # it 'sends 2 emails' do
  #   expect { DailyDigestJob.perform_now }.to change { ActionMailer::Base.deliveries.count }.by(2)
  # end

  it 'use QuestionMailer to send emails' do
    users.each { |user| expect(QuestionMailer).to receive(:daily_digest).with(user.reload).and_call_original }
    DailyDigestJob.perform_now
  end
end
