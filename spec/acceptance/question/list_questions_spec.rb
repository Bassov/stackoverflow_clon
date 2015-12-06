# encoding: utf-8
require_relative '../acceptance_helper'

feature 'list questions', '
  In order to view questions
  As an guest
  I can view questions page
' do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2, user: user) }

  scenario 'guest visit questions page' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end
