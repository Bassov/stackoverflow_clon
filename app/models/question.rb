# encoding: utf-8
# One day there would be comment about this model
class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :user

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank

  validates :title, :body, :user_id, presence: true
end
