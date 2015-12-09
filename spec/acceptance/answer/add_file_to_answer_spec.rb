# encoding: utf-8
require_relative '../acceptance_helper'

feature 'Add file to answer', '
  In order to specify my answer
  As an authenticated user
  I want to be able to attach file to answer
' do
  given(:user) { create :user }
  given!(:question) { create :question }

  scenario 'Authenticate user answers question and uploads file', js: true do
    sign_in user

    visit question_path(question)
    fill_in 'new-answer-body', with: 'Test body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Ответить'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end