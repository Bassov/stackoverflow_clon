# encoding: utf-8
class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])
    return redirect_to :back, notice: 'Вы не являетесь автором вопроса' unless current_user.author_of(@answer)
    @answer.destroy
    redirect_to :back, notice: 'Ответ успешно удален'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
