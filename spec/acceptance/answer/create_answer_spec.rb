# encoding: utf-8
require_relative '../acceptance_helper'

feature 'Answer questions', '
  In order to help users
  As an authenticated user
  I want to be able to answer questions
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user answers question', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'Test body'
    click_on 'Ответить'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'Test body'
    end
  end

  scenario 'Authenticated user tries to answer question with invalid attributes', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: nil
    click_on 'Ответить'

    expect(page).to have_content 'Ответ не может быть пустым'
  end

  scenario 'Non-authenticated user tries to answer question' do
    visit question_path(question)
    fill_in 'Body', with: 'Test body'
    click_on 'Ответить'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
