# encoding: utf-8
require 'rails_helper'

feature 'Create question', '
  In order to get answers from community
  As an authenticated user
  I want to be able to ask questions
' do
  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

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

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
