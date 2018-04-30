# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :vote do
    rating 1
    votable_id 10
    votable_type "Answer"
    user
  end
end
