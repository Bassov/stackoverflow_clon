# frozen_string_literal: true

class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
end
