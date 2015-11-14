class AnswersController < ApplicationController
  before_action :set_answer, only: [:destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to question_path(@question)
    else
      render :create
    end
  end

  def destroy
    @answer.destroy
    redirect_to @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
