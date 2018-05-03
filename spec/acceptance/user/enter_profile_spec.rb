# encoding: utf-8
# frozen_string_literal: true

require_relative "../acceptance_helper"

feature "Enter profile", '
  In order to view information about my profile
  As an authenticated user
  I want to be able to enter my profile
', integration: true, ui: true do
  given(:user) { create :user }
  given!(:questions) { create_list(:question, 2, user: user) }

  scenario "authenticated user enters his profile", positive: true do
    sign_in user
    expect(page).to have_link "Профиль"

    click_on "Профиль"
    expect(page).to have_link "Редактировать профиль"
    expect(page).to have_content "Мои вопросы"
    questions.each { |question| expect(page).to have_content question.title }
  end

  scenario "guest tries to enter his profile", negastive: true do
    visit "/"
    expect(page).to_not have_link "Профиль"
  end

end
