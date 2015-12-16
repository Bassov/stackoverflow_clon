# encoding: utf-8
class Question < ActiveRecord::Base
  include Attachable

  has_many :answers, dependent: :destroy
  has_many :votes, as: :votable
  belongs_to :user

  validates :title, :body, :user_id, presence: true
end
