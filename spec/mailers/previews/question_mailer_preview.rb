# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/question_mailer
class QuestionMailerPreview < ActionMailer::Preview
  def daily_digest
    QuestionMailer.daily_digest(User.find(1))
  end

  def new_answer
    QuestionMailer.new_answer(Answer.find(231))
  end
end
