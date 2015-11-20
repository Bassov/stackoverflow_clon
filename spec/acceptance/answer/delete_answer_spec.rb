# encoding: utf-8
require 'rails_helper'

feature 'Delete answer', '
  In order to delete answer
  As an author of answer
  I want to be able to delete answer
' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Author of answer deletes answer' do
    sign_in(user)

    visit questions_path
    click_on question.title
    page.first(:link, 'Удалить').click

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Ответ успешно удален'
    expect(page).to_not have_content answer.body
  end
end