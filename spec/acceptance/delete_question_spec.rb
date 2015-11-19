# encoding: utf-8
require 'rails_helper'

feature 'Delete question', '
  In order to delete quetion
  As an author of question
  I want to be able to delete question
' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }

  scenario 'Author of question deletes question' do
    sign_in(user)
    question = create(:question, user: user)

    visit questions_path
    click_on question.title
    click_on 'Удалить'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Успешно удалено'
  end

  scenario 'Non-author of question tries to delete question' do
    sign_in(user)
    question = create(:question, user: another_user)

    visit questions_path
    click_on question.title
    click_on 'Удалить'

    expect(page).to have_content 'Вы не являетесь автором вопроса'
  end
end