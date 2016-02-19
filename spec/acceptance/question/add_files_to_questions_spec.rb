# encoding: utf-8
require_relative '../acceptance_helper'

feature 'Add file to question', '
  In order to specify my trouble
  As an authenticated user
  I want to be able to attach files to questions
' do
  given(:user) { create :user }

  background do
    sign_in user
    visit new_question_path
  end

  scenario 'Authenticated user attaches file when creates question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
    click_on 'Добавить файл'
    all('input[type="File"]')[0].set("#{Rails.root}/spec/spec_helper.rb")
    click_on 'Добавить файл'
    all('input[type="File"]')[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Сохранить'

    expect(page).to have_link 'spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb'
  end
end
