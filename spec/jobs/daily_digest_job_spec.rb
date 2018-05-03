# frozen_string_literal: true

require "rails_helper"

RSpec.describe DailyDigestJob, type: :jobs, integration: true do
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  let!(:users) { create_list :user, 2 }
  let!(:question) { create :question, user: users.first }

  it "sends 2 emails", positive: true do
    expect { DailyDigestJob.perform_now }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  it "use QuestionMailer to send emails", positive: true do
    users.each { |user| expect(QuestionMailer).to receive(:daily_digest).with(user).and_call_original }
    DailyDigestJob.perform_now
  end
end
