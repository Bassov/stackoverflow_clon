# encoding: utf-8
# frozen_string_literal: true

require_relative "../acceptance_helper"

feature "User sign in with vk", '
  In order to simplify authentication
  As a guest
  I want to be able to sign in with vk
', integration: true, ui: true do
  scenario "user signs in with valid account", positive: true do
    visit "users/sign_in"
    vk_oauth
    click_on "Sign in with Vk"

    expect(page).to have_content("Successfully authenticated from vk account.")
    expect(page).to have_link("Выйти")
  end

  scenario "user signs in with invalid account", negative: true do
    visit "users/sign_in"
    OmniAuth.config.mock_auth[:vk] = :invalid_credentials
    click_on "Sign in with Vk"

    expect(page).to have_content("Could not authenticate you from Vk")
  end
end
