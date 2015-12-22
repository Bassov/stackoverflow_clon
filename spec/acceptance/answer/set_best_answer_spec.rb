# encoding: utf-8
require_relative '../acceptance_helper'

feature 'Set the best answer', '
  In order to mark the best answer for my question
  As an author of question
  I want to be able to mark answers as the best
' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, question: question, user: user) }

  scenario 'Author of question marks best answer', js: true do
    sign_in user

    last_answer_content = answers.last.body

    visit question_path(question)

    within "#answer_#{answers.last.id}" do
      click_on 'Лучший ответ'
    end
    sleep(2)

    within "#answer_#{question.answers.first.id}" do
      expect(page).to have_content last_answer_content
    end
  end

  scenario 'Non-author of question can`t see button' do
    sign_in another_user

    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Лучший ответ'
    end
  end
end
