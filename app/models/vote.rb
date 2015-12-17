class Vote < ActiveRecord::Base
  validates :user_id, presence: true

  belongs_to :votable, polymorphic: true
  belongs_to :user
end
