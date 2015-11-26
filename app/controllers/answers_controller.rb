# encoding: utf-8
class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: :destroy
  before_action :check_authority, only: :destroy

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer.destroy
    redirect_to :back, notice: 'Ответ успешно удален'
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def check_authority
    redirect_to :back, notice: 'Вы не являетесь автором вопроса' unless current_user.author_of(@answer)
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
