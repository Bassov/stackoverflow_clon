# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :set_question
  respond_to :js

  def create
    authorize! :create, @question
    @question.subscribe(current_user)
  end

  def destroy
    authorize! :create, @question
    @question.unsubscribe(current_user)
  end

  private

    def set_question
      @question = Question.find(params[:question_id])
    end
end
