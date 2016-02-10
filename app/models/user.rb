# encoding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :answers
  has_many :questions
  has_many :votes
  has_many :comments

  def author_of?(object)
    id == object.user_id
  end

  def non_author_of?(object)
    !author_of?(object)
  end

  def vote_for(votable, rating)
    vote = votes.new(votable: votable, rating: rating)
    vote.save
  end

  def unvote_for(votable)
    votes.where(votable: votable).delete_all
  end

  def voted_for?(votable)
    votes.where(votable: votable).any?
  end
end
