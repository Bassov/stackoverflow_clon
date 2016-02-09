# encoding: utf-8
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except:  [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :check_authority, only: [:edit, :update, :destroy]
  after_action :publish_question, only: :create

  def index
    respond_with(@questions = Question.all)
  end

  def show
    gon.current_user = user_signed_in? ? current_user.id : nil
    respond_with @question
  end

  def new
    respond_with(@question = current_user.questions.new)
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(questions_params))
  end

  def update
    @question.update(questions_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def publish_question
    PrivatePub.publish_to '/questions', question: @question.to_json if @question.valid?
  end

  def check_authority
    redirect_to :back, notice: 'Вы не являетесь автором вопроса' unless current_user.author_of?(@question)
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
