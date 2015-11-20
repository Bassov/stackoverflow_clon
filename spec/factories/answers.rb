# encoding: utf-8
FactoryGirl.define do
  sequence :answer do |n|
    "MyAnswerString#{n}"
  end

  factory :answer do
    body
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
