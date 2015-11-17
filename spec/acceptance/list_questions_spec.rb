# encoding: utf-8
require 'rails_helper'

feature 'list questions', '
  In order to view questions
  As an guest
  I can view questions page
' do
  scenario 'guest visit questions page' do
    questions = create_list(:question, 2)

    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end
