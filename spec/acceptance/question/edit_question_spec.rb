# encoding: utf-8
require_relative '../acceptance_helper'

feature 'Edit question', '
  In order to edit my question
  As an author of question
  I want to be able to edit my question
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Author of question edits it' do
    sign_in(user)

    visit questions_path
    click_on question.title
    click_on 'Изменить'
    fill_in 'Title', with: 'Edited title'
    fill_in 'Body', with: 'Edited body'
    click_on 'Изменить'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Question was successfully updated'
    expect(page).to have_content 'Edited title'
    expect(page).to have_content 'Edited body'
  end
end
