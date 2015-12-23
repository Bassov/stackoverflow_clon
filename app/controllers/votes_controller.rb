# encoding: utf-8
class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_votable
  before_action :check_authority

  def vote
    rating = params[:rating]

    if current_user.voted_for?(@votable)
      current_user.unvote_for(@votable)
    else
      current_user.vote_for(@votable, rating)
    end
  end

  private

  def check_authority
    render :vote if current_user.author_of?(@votable)
  end

  def set_votable
    klass = params[:votable_type].to_s.capitalize.constantize
    @votable = klass.find(params[:votable_id])
  end
end
