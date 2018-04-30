# encoding: utf-8
# frozen_string_literal: true

class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_votable

  def create_vote
    authorize! :create_vote, @votable
    return current_user.unvote_for(@votable) if current_user.voted_for?(@votable)
    current_user.vote_for(@votable, params[:rating])
  end

  private

    def set_votable
      klass = params[:votable_type].to_s.capitalize.constantize
      @votable = klass.find(params[:votable_id])
    end
end
