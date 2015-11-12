# encoding: utf-8
class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end
end
