# encoding: utf-8
class Answer < ActiveRecord::Base
  include Attachable

  belongs_to :question
  belongs_to :user

  has_many :votes, as: :votable

  validates :body, :question_id, :user_id, presence: true

  default_scope { order(best: :desc).order(:created_at) }

  def make_best
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      fail ActiveRecord::Rollback unless update(best: true)
    end
  end

  def vote_up(user)
    self.votes.create(rating: 1, user_id: user.id)
  end

  def vote_down(user)
    self.votes.create(rating: -1, user_id: user.id)
  end

  def rating
    self.votes.sum(:rating)
  end
end
