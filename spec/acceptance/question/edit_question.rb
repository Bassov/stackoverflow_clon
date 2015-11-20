# encoding: utf-8
require 'rails_helper'

feature 'Edit question', '
  In order to edit my question
  As an author of question
  I want to be able to edit my question
' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }

  scenario 'Author of question edits it' do
    sign_in(user)
    question = create(:question, user: user)

    visit questions_path
    click_on question.title
    clic_on 'Изменить'
    fill_in 'Title', with: 'Edited title'
    fill_in 'Body', with: 'Edited body'
    click_on 'Изменить'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Вопрос успешно отредактирован'
    expect(page).to have_content 'Edited title'
    expect(page).to have_content 'Edited body'
  end
end