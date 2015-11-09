# encoding: utf-8
# One day there would be comment about this model
class Question < ActiveRecord::Base
  has_many :answers

  validates :title, :body, presence: true
end
