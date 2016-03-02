class QuestionMailer < ApplicationMailer

  def daily_digest
    @questions = Question.find_by 'created_at > ?', Time.now.midnight

    User.find_each do |user|
      mail(to: user.email, subject: 'Список вопросов за день')
    end
  end
end
