# encoding: utf-8
# frozen_string_literal: true

require_relative "../acceptance_helper"

feature "Sign out", '
  In order to leave session
  As an authenticated user
  I want to be able to sign out
' do
  given(:user) { create(:user) }

  scenario "authenticated user signs out" do
    sign_in(user)

    click_on "Выйти"
    expect(page).to have_content "Signed out successfully."
  end
end
