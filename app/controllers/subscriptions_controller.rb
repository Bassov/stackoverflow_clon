class SubscriptionsController < ApplicationController
  before_action :set_question
  respond_to :js

  authorize_resource

  def create
    @question.subscribe(current_user)
  end

  def destroy
    @question.unsubscribe(current_user)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
