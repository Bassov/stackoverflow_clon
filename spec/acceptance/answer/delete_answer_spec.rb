# encoding: utf-8
require 'rails_helper'

feature 'Delete answer', '
  In order to delete answer
  As an author of answer
  I want to be able to delete answer
' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }

  scenario 'Author of answer deletes answer' do
    sign_in(user)
    question = create(:question)
    create(:answer, question: question, user: user)

    visit questions_path
    click_on question.title
    page.first(:link, 'Удалить').click

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Ответ успешно удален'
  end

  scenario 'Non-author of answer tries to delete answer' do
    sign_in(user)
    question = create(:question)
    create(:answer, question: question, user: another_user)

    visit questions_path
    click_on question.title
    page.first(:link, 'Удалить').click

    expect(page).to have_content 'Вы не являетесь автором ответа'
  end
end