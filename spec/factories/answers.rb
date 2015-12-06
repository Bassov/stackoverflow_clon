# encoding: utf-8
FactoryGirl.define do
  factory :answer do
    user
    body
    question
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
