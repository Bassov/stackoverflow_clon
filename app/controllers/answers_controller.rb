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
    @answer.save
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def make_best
    @answer.make_best if current_user.author_of?(@question)
  end

  def vote_up
    @answer.vote_up(current_user.id)
    respond_to do |format|
      if @answer.save
        format.json { render json: @answer.rating }
      end
    end
  end

  def vote_down
    @answer.vote_down(current_user.id)
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
