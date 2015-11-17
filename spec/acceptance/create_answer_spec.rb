# encoding: utf-8
require 'rails_helper'

feature 'Answer questions', '
  In order to help users
  As an authenticated user
  I want to be able to answer questions
' do
  given(:user) {create(:user)}
  given(:question) {create(:question)}

  scenario 'Authenticated user answers question' do
    sign_in(user)
    question

    visit questions_path
    click_on question.title
    click_on 'Ответить'
    fill_in 'Body', with: 'Test body'
    click_on 'Ответить'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Test body'
  end

  scenario 'Non-authenticateed user tries to answer question' do
    question

    visit questions_path
    click_on question.title
    click_on 'Ответить'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
