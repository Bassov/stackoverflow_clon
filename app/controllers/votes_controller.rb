# encoding: utf-8
class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_votable
  before_action :check_authority

  def vote_up
    current_user.vote_for(@votable, 1)
    render :vote
  end

  def vote_down
    current_user.vote_for(@votable, -1)
    render :vote
  end

  def unvote
    current_user.unvote_for(@votable)
    render :vote
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
