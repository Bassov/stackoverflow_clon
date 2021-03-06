# encoding: utf-8
# frozen_string_literal: true

module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"
  end
end
