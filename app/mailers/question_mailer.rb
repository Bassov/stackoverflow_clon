class QuestionMailer < ApplicationMailer

  def daily_digest(user)
    @questions = Question.find_by 'created_at > ?', Time.now.midnight

    mail(to: user.email, subject: 'Список вопросов за день')
  end
end
