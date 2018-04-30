# encoding: utf-8
# frozen_string_literal: true

class Authorization < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :provider, :uid, presence: true
end
