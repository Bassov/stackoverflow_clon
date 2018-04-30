# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :comment do
    body "test1"
    user
  end
end
