# encoding: utf-8
class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, except: :create
  before_action :set_answer_question, only: [:update, :make_best]
  before_action :set_question, only: :create
  after_action :publish_answer, only: :create

  respond_to :js

  authorize_resource

  def update
    respond_with(@answer.update(answer_params))
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def make_best
    respond_with(@answer.make_best) if current_user.author_of?(@question)
  end

  private

  def set_answer_question
    @question = @answer.question
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def publish_answer
    if @answer.valid?
      attachments = []

      @answer.attachments.each do |attachment|
        attachments << { attachment: attachment, file_name: attachment.file.identifier }
      end

      PrivatePub.publish_to "/questions/#{@question.id}/answers",         answer: @answer.to_json,
                                                                          answer_question: @answer.question.to_json,
                                                                          attachments: attachments.to_json
    end
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end
