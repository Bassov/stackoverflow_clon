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

  it_behaves_like 'Acceptance attachable' do
    given(:save_button) { 'Сохранить' }

    def fill_form
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test body'
    end
  end
end
