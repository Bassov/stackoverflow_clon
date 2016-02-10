# encoding: utf-8
require_relative '../acceptance_helper'

feature 'Add comments', '
  In order to discus answer
  As an authenticated user
  I want to be able to add comments
' do
  given(:user) { create :user }
  given!(:question) { create :question }
  given!(:answer) { create :answer, question: question }

  scenario 'Authenticated user adds comment to answer', js: true do
    sign_in user

    visit question_path(question)
    within "#answer_#{answer.id}" do
      click_on 'Комментировать'
      fill_in 'Body', with: 'new comment'
      click_on 'Сохранить'

      expect(page).to_not have_selector 'textarea'
      expect(page).to have_content 'new comment'
    end
  end
end
