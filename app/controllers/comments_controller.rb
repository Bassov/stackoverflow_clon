# encoding: utf-8
class CommentsController < ApplicationController
  before_action :set_commentable, only: :create
  after_action :publish_comment, only: :create

  def create
    @comment = @commentable.comments.build(comments_params)
    @comment.user = current_user
  end

  private

  def set_commentable
    @commentable = Question.find(params[:question_id]) if params[:question_id]
    @commentable ||= Answer.find(params[:answer_id])
  end

  def publish_comment
    question_id = if @commentable.is_a?(Answer)
                    @commentable.question.id
                  else
                    @commentable.id
                  end

    if @comment.save
      PrivatePub.publish_to "/questions/#{question_id}/comments", comment: @comment.to_json
    end
  end

  def comments_params
    params.require(:comment).permit(:body)
  end
end
