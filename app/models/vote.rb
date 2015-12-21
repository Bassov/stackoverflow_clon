class Vote < ActiveRecord::Base
  validates :user_id, presence: true

  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id] }

  belongs_to :votable, polymorphic: true
  belongs_to :user

  scope :upvotes,   -> { where(rating: 1) }
  scope :downvotes, -> { where(rating: -1) }
  scope :rating,    -> { sum(:rating) }
end
