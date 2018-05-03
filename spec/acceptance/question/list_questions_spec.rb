# encoding: utf-8
# frozen_string_literal: true

require_relative "../acceptance_helper"

feature "list questions", '
  In order to view questions
  As an guest
  I can view questions page
', integration: true, ui: true do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2) }

  scenario "guest visit questions page", positive: true do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end
