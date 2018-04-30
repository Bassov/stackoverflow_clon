# encoding: utf-8
# frozen_string_literal: true

class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :user_id, :body, presence: true
end
