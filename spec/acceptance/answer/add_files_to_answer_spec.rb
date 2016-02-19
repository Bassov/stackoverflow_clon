# encoding: utf-8
require_relative '../acceptance_helper'

feature 'Add files to answer', '
  In order to specify my answer
  As an authenticated user
  I want to be able to attach files to answer
' do
  given(:user) { create :user }
  given!(:question) { create :question }

  scenario 'Authenticate user answers question and uploads files', js: true do
    sign_in user

    visit question_path(question)
    fill_in 'new-answer-body', with: 'Test body'
    click_on 'Добавить файл'
    all('input[type="File"]')[0].set("#{Rails.root}/spec/spec_helper.rb")
    click_on 'Добавить файл'
    all('input[type="File"]')[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Ответить'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end
  end
end
