# encoding: utf-8
# One day there would be comment about this model
class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, :question_id, presence: true
end
