class QuestionMailer < ApplicationMailer

  def daily_digest(user)
    @questions = Question.find_by 'created_at > ?', Time.now.midnight
    mail(to: user.email, subject: 'Список вопросов за день') if @questions
  end

  def new_answer(user, answer, question)
    @answer = answer
    @question = question

    mail(to: user.email, subject: "Новый ответ на вопрос #{@question.title}")
  end
end
