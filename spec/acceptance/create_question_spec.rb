require 'rails_helper'

feature 'Create question', %q{
  In order to get answers from community
  As an authenticated user
  I want to be able to ask questions
} do

  scenario 'Authenticated user creates question' do
    User.create!(email: 'user@user.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@user.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    visit questions_path
    click_on 'Задать вопрос'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
    click_on 'Сохранить'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Test question'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Задать вопрос'

    expect(page). to have_content 'You need to sign in or sign up before continuing.'
  end

end
