# encoding: utf-8
require_relative '../acceptance_helper'

feature 'Delete question', '
  In order to delete question
  As an author of question
  I want to be able to delete question
' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Author of question deletes question' do
    sign_in(user)

    visit questions_path
    click_on question.title
    click_on 'Удалить'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Question was successfully destroyed'
    expect(page).to_not have_content question.title
  end
end
