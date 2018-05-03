# encoding: utf-8
# frozen_string_literal: true

require_relative "../acceptance_helper"

feature "registration", '
  In oreder to become user
  As a guest
  I want to be able to sign up
', integration: true, ui: true do
  scenario "guest signs up with correct data", positive: true do
    visit root_path
    click_on "Зарегистрироваться"
    fill_in "Email", with: "user@user.com"
    fill_in "Password", with: "12345678"
    fill_in "Password confirmation", with: "12345678"
    click_on "Sign up"

    expect(page).to have_content "Welcome! You have signed up successfully."
    expect(current_path).to eq root_path
  end

  scenario "guest tries to sign up with wrong data", negative: true do
    visit root_path
    click_on "Зарегистрироваться"
    fill_in "Email", with: "1"
    fill_in "Password", with: "2"
    fill_in "Password confirmation", with: "3"
    click_on "Sign up"

    expect(page).to have_content "Email is invalid"
    expect(page).to have_content "Password confirmation doesn't match Password"
    expect(page).to have_content "Password is too short (minimum is 8 characters)"
  end
end
