# encoding: utf-8
FactoryGirl.define do
  factory :question do
    title 'MyQuestionString'
    body 'MyQuestionText'
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
