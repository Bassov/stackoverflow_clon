# encoding: utf-8
# frozen_string_literal: true

require_relative "../acceptance_helper"

feature "Vote question", '
  In order to mark question
  As an authenticated user
  I want to be able to vote for question
', integration: true, ui: true do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:user_question) { create :question, user: user }
  given(:selector) { ".question" }

  it_behaves_like "Acceptance votable"

  scenario "Author of votable cant vote for it", negative: true do
    sign_in user
    visit question_path(user_question)

    within selector do
      expect(page).to_not have_content "+"
      expect(page).to_not have_content "-"
    end
  end
end
