# encoding: utf-8
# frozen_string_literal: true

require_relative "../acceptance_helper"

feature "Edit answer", '
  In order to fix mistakes
  As an author of answer
  I want to be able to edit my answer
', integration: true, ui: true do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario "Author of answer edits his answer", js: true, positive: true do
    sign_in(user)

    visit question_path(question)
    within "#answer_#{answer.id}" do
      click_on "Изменить"
      fill_in "Body", with: "Edited answer"
      click_on "Сохранить"

      expect(page).to_not have_content answer.body
      expect(page).to_not have_selector "textarea"
      expect(page).to have_content "Edited answer"
      expect(page).to have_link "Изменить"
    end
  end

  scenario "Non-authenticated user tries to edit answer", negative: true do
    visit question_path(question)

    expect(page).to_not have_content "Изменить"
  end
end
