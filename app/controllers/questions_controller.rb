# encoding: utf-8
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except:  [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :check_authority, only: [:edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = current_user.questions.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(questions_params)
    if @question.save
      redirect_to questions_path
    else
      render :new
    end
  end

  def update
    if @question.update(questions_params)
      redirect_to @question, notice: 'Вопрос успешно отредактирован'
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Успешно удалено'
  end

  private

  def check_authority
    redirect_to :back, notice: 'Вы не являетесь автором вопроса' unless current_user.author_of?(@question)
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body)
  end
end
