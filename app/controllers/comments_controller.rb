class CommentsController < ApplicationController
  def create
    @commentable = params[:question_id].present? ? Question.find(params[:question_id]) : Answer.find(params[:answer_id])

    @comment = @commentable.comments.create(comments_params)
    @comment.user = current_user

    question_id = if @commentable.is_a?(Answer)
                    @commentable.question.id
                  else
                    @commentable.id
                  end

    if @comment.save
      PrivatePub.publish_to "/questions/#{question_id}/comments", {
          comment: @comment.to_json,
      }
    end

    render :create
  end

  private

  def comments_params
    params.require(:comment).permit(:body)
  end
end
