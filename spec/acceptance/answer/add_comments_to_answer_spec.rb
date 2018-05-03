# encoding: utf-8
# frozen_string_literal: true

require_relative "../acceptance_helper"

feature "Add comments", '
  In order to discus answer
  As an authenticated user
  I want to be able to add comments
', integration: true, ui: true do
  given(:user) { create :user }
  given!(:question) { create :question }
  given!(:answer) { create :answer, question: question }

  it_behaves_like "Acceptance commentable" do
    given(:selector) { ".answer" }
  end
end
