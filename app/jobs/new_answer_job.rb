class NewAnswerJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    question = answer.question

    question.subscribers.each do |user|
      QuestionMailer.new_answer(user, answer, question).deliver_later
    end
  end
end
