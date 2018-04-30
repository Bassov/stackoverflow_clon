# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  sequence :title do |n|
    "MyString#{n}"
  end

  sequence :body do |n|
    "MyText#{n}"
  end

  factory :question do
    title
    body
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
