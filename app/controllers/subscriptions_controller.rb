class SubscriptionsController < ApplicationController
  before_action :set_question
  respond_to :js

  def create
    respond_with(@question.subscribe(current_user))
  end

  def destroy
    respond_with(@question.unsubscribe(current_user))
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
