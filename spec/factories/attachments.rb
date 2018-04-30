# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :attachment do
    file { File.new(Rails.root.join("spec", "spec_helper.rb")) }
  end
end
