# encoding: utf-8
FactoryGirl.define do
  sequence :title do |n|
    "MyQuestionString#{n}"
  end

  sequence :body do |n|
    "MyQuestionText#{n}"
  end

  factory :question do
    title
    body
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
