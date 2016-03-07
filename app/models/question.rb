# encoding: utf-8
class Question < ActiveRecord::Base
  include Attachable

  has_many :answers, dependent: :destroy

  has_many :votes, as: :votable
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  belongs_to :user

  validates :title, :body, :user_id, presence: true

  def subscribe(user)
    subscribers << user unless subscribers.include? user
  end

  def unsubscribe(user)
    subscribers.find_by(id: user.id).destroy if subscribers.include? user
  end
end
