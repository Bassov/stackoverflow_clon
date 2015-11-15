# encoding: utf-8
FactoryGirl.define do
  factory :answer do
    body 'MyString'
    text 'MyString'
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    text nil
  end
end
