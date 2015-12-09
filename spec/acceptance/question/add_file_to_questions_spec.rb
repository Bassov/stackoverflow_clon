# encoding: utf-8
require_relative '../acceptance_helper'

feature 'Add file to question', '
  In order to specify my trouble
  As an authenticated user
  I want to be able to attach files to questions
' do
  given(:user) { create :user }

  scenario 'Authenticated user attaches file when creates question' do
    sign_in user

    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Сохранить'

    expect(page).to have_content 'spec_helper.rb'
  end
end