# encoding: utf-8
class Question < ActiveRecord::Base
  include Attachable

  has_many :answers, dependent: :destroy
  has_many :votes, as: :votable
  has_many :comments, as: :commentable
  belongs_to :user

  validates :title, :body, :user_id, presence: true
end
