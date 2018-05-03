# encoding: utf-8
# frozen_string_literal: true

require_relative "../acceptance_helper"

feature "Create question", '
  In order to get answers from community
  As an authenticated user
  I want to be able to ask questions
', integration: true, ui: true do
  given(:user) { create(:user) }

  scenario "Authenticated user creates question", positive: true do
    sign_in(user)

    visit questions_path
    click_on "Задать вопрос"
    fill_in "Title", with: "Test question"
    fill_in "Body", with: "Test body"
    click_on "Сохранить"

    expect(page).to have_content "Test question"
  end

  scenario "Non-authenticated user tries to create question", negative: true do
    visit questions_path

    expect(page).to_not have_content "Задать вопрос"
  end
end
