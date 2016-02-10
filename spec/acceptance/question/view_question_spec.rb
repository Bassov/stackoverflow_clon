# encoding: utf-8
require_relative '../acceptance_helper'

feature 'View question', '
  In order to solve problem
  As a guest
  I want to be able to view existing questions
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'guest views question' do
    visit questions_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
