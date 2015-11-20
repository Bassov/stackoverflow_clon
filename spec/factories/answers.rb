# encoding: utf-8
FactoryGirl.define do
  factory :answer do
    body 'MyAnswerString'
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
