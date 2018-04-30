# encoding: utf-8
# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: :create
  after_action :publish_comment, only: :create

  respond_to :js

  authorize_resource

  def create
    respond_with(@comment = @commentable.comments.create(comments_params.merge(user: current_user)))
  end

  private

    def set_commentable
      @commentable = Question.find(params[:question_id]) if params[:question_id]
      @commentable ||= Answer.find(params[:answer_id])
    end

    def publish_comment
      if @comment.valid?
        question_id = if @commentable.is_a?(Answer)
          @commentable.question.id
        else
          @commentable.id
        end

        PrivatePub.publish_to "/questions/#{question_id}/comments", comment: @comment.to_json
      end
    end

    def comments_params
      params.require(:comment).permit(:body)
    end
end
