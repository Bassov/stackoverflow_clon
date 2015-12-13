# encoding: utf-8
require_relative '../acceptance_helper'

feature 'Delete answer', '
  In order to delete answer
  As an author of answer
  I want to be able to delete answer
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Author of answer deletes answer', js: true do
    sign_in(user)

    visit question_path(question)
    within("#answer_#{answer.id}") do
      click_on 'Удалить'
    end

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Ответ успешно удален'
    expect(page).to_not have_content answer.body
  end
end
