class Vote < ActiveRecord::Base
  validates :user_id, presence: true

  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id] }

  belongs_to :votable, polymorphic: true
  belongs_to :user
end
