# encoding: utf-8
class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable

  accepts_nested_attributes_for :attachments

  validates :body, :question_id, :user_id, presence: true

  default_scope { order(best: :desc).order(:created_at) }

  def make_best
    ActiveRecord::Base.transaction do
      self.question.answers.update_all(best: false)
      raise ActiveRecord::Rollback unless self.update(best: true)
    end
  end
end
