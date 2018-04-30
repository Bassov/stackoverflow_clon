# encoding: utf-8
# frozen_string_literal: true

require_relative "../acceptance_helper"

feature "Delete files", '
  In order to remove unnecessary files
  As an author of message
  I want to be able to delete files
' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:question_attachment) { create(:attachment, attachable: question) }
  given!(:answer_attachment) { create(:attachment, attachable: answer) }

  scenario "Non-author of message can`t see delete button" do
    sign_in another_user
    visit question_path(question)

    within("#attachment_#{question_attachment.id}") do
      expect(page).to_not have_content "Удалить"
    end

    within("#attachment_#{answer_attachment.id}") do
      expect(page).to_not have_content "Удалить"
    end
  end

  scenario "Author of message can delete its files", js: true do
    sign_in user
    visit question_path(question)

    within("#attachment_#{question_attachment.id}") do
      click_on "Удалить"
    end

    within("#attachment_#{answer_attachment.id}") do
      click_on "Удалить"
    end

    expect(page).to_not have_link "spec_helper.rb", href: "/uploads/attachment/file/3/spec_helper.rb"
    expect(page).to_not have_link "spec_helper.rb", href: "/uploads/attachment/file/4/spec_helper.rb"
  end
end
