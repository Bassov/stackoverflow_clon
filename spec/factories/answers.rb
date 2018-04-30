# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :answer do
    user
    body
    question
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end
end
