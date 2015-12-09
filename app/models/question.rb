# encoding: utf-8
# One day there would be comment about this model
class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments
  belongs_to :user

  validates :title, :body, :user_id, presence: true
end
