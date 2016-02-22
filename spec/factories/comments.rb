# encoding: utf-8
FactoryGirl.define do
  factory :comment do
    body 'test1'
    user
  end
end
