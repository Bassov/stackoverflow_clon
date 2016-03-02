# Preview all emails at http://localhost:3000/rails/mailers/question_mailer
class QuestionMailerPreview < ActionMailer::Preview
  def daily_digest
    QuestionMailer.daily_digest
  end
end
