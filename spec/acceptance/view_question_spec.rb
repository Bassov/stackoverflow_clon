# encoding: utf-8
require 'rails_helper'

feature 'View question', '
  In order to solve problem
  As a guest
  I want to be able to view existing questions
' do
  scenario 'guest views question' do
    question = create(:question)
    answer = create(:answer, question: question)

    visit questions_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end
end
