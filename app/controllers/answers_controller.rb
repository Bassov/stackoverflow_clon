# encoding: utf-8
class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, except: :create
  before_action :set_answer_question, only: [:update, :make_best]

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user

    attachments = []

    @answer.attachments.each do |attachment|
      attachments << { attachment: attachment, file_name: attachment.file.identifier }
    end

    if @answer.save
      PrivatePub.publish_to "/questions/#{@question.id}/answers", {
          answer: @answer.to_json,
          answer_question: @answer.question.to_json,
          attachments: attachments.to_json,
          rating: @answer.votes.rating.to_json,
          answer_class: @answer.class.to_s.to_json
      }
    end

    render :create
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def make_best
    @answer.make_best if current_user.author_of?(@question)
  end

  private

  def set_answer_question
    @question = @answer.question
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end
