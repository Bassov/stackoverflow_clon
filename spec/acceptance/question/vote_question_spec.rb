# encoding: utf-8
require_relative '../acceptance_helper'

feature 'Vote question', '
  In order to mark question
  As an authenticated user
  I want to be able to vote for question
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:user_question) { create :question, user: user }
  given(:selector) { '.question' }

  it_behaves_like 'Acceptance votable'

  scenario 'Author of votable cant vote for it' do
    sign_in user
    visit question_path(user_question)

    within selector do
      expect(page).to_not have_content '+'
      expect(page).to_not have_content '-'
    end
  end
end
