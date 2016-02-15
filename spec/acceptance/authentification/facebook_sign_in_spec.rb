# encoding: utf-8
require_relative '../acceptance_helper'

feature 'User sign in with facebook', '
  In order to simplify authentication
  As a guest
  I want to be able to sign in with Facebook
' do

  scenario 'user signs in with valid account' do
    visit 'users/sign_in'
    facebook_oauth
    click_on 'Sign in with Facebook'

    expect(page).to have_content('Successfully authenticated from Facebook account.')
    expect(page).to have_link('Выйти')
  end

  scenario 'user signs in with invalid account' do
    visit 'users/sign_in'
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    click_on 'Sign in with Facebook'


    expect(page).to have_content('Could not authenticate you from Facebook')
  end
end