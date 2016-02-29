# encoding: utf-8
require_relative '../acceptance_helper'

feature 'Vote answer', '
  In order to mark answers
  As an authenticated user
  I want to be able to create for answers
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:user_answer) { create(:answer, user: user, question: question) }
  given!(:answer) { create(:answer, question: question) }
  given(:selector) { "#answer_#{answer.id}" }

  it_behaves_like 'Acceptance votable'

  scenario 'Author of votable cant vote for it' do
    sign_in user
    visit question_path(question)

    within "#answer_#{user_answer.id}" do
      expect(page).to_not have_content '+'
      expect(page).to_not have_content '-'
    end
  end
end
