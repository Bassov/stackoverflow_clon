# encoding: utf-8
require_relative '../acceptance_helper'

feature 'Enter profile', '
  In order to view information about my profile
  As an authenticated user
  I want to be able to enter my profile
' do
  given(:user) { create :user }
  given!(:question) { create :question, user: user }

  scenario 'authenticated user enters his profile' do
    sign_in user
    expect(page).to have_link 'Профиль'

    click_on 'Профиль'
    expect(page).to have_link 'Редактировать профиль'
  end

  scenario 'guest tries to enter his profile' do
    visit '/'
    expect(page).to_not have_link 'Профиль'
  end

end