# encoding: utf-8
class Answer < ActiveRecord::Base
  include Attachable

  belongs_to :question
  belongs_to :user

  has_many :votes, as: :votable
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true

  default_scope { order(best: :desc).order(:created_at) }

  after_create :send_notification

  def make_best
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      fail ActiveRecord::Rollback unless update(best: true)
    end
  end

  private

  def send_notification
    NewAnswerJob.perform_later(self)
  end
end
