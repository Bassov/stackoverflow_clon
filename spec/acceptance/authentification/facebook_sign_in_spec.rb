# encoding: utf-8
# frozen_string_literal: true

require_relative "../acceptance_helper"

feature "User sign in with facebook", '
  In order to simplify authentication
  As a guest
  I want to be able to sign in with Facebook
', integration: true, ui: true do
  scenario "user signs in with valid account", positive: true do
    visit "users/sign_in"
    facebook_oauth
    click_on "Sign in with Facebook"

    expect(page).to have_content("Successfully authenticated from Facebook account.")
    expect(page).to have_link("Выйти")
  end

  scenario "user signs in with invalid account", negative: true do
    visit "users/sign_in"
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    click_on "Sign in with Facebook"

    expect(page).to have_content("Could not authenticate you from Facebook")
  end

  scenario "provider gives hash without provider field", negative: true do
    visit "users/sign_in"
    facebook_oauth_no_provider
    click_on "Sign in with Facebook"

    expect(page).to have_content("Could not authenticate you from Facebook")
  end

  scenario "provider gives hash without uid field", negative: true do
    visit "users/sign_in"
    facebook_oauth_no_uid
    click_on "Sign in with Facebook"

    expect(page).to have_content("Could not authenticate you from Facebook")
  end

  scenario "provider gives hash without email field", negative: true do
    visit "users/sign_in"
    facebook_oauth_no_email
    click_on "Sign in with Facebook"

    expect(page).to have_content("Successfully authenticated from Facebook account.")
    expect(page).to have_link("Выйти")
  end
end
