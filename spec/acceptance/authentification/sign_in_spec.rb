# encoding: utf-8
# frozen_string_literal: true

require_relative "../acceptance_helper"

feature "User sign in", '
  In order to ask questions
  As a user
  I want to be able to sign in
', integration: true, ui: true do
  given(:user) { create(:user) }

  scenario "Registered user try to sign in", positive: true do
    sign_in(user)

    expect(page).to have_content "Signed in successfully."
    expect(current_path).to eq root_path
  end

  scenario "Non-registred user try to sign in", negative: true do
    visit new_user_session_path
    fill_in "Email", with: "non-user@user.com"
    fill_in "Password", with: "12345678"
    click_on "Log in"

    expect(page).to have_content "Invalid email or password."
    expect(current_path).to eq new_user_session_path
  end
end
