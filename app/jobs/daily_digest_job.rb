class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    User.find_each do |user|
      QuestionMailer.daily_digest(user).deliver_later
    end
  end
end
