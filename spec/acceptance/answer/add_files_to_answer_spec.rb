# encoding: utf-8
# frozen_string_literal: true

require_relative "../acceptance_helper"

feature "Add files to answer", '
  In order to specify my answer
  As an authenticated user
  I want to be able to attach files to answer
', integration: true, ui: true do
  given(:user) { create :user }
  given!(:question) { create :question }

  background do
    sign_in user
    visit question_path(question)
  end

  it_behaves_like "Acceptance attachable" do
    given(:save_button) { "Ответить" }

    def fill_form
      fill_in "new-answer-body", with: "Test body"
    end
  end
end
