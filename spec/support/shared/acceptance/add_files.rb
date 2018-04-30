# frozen_string_literal: true

shared_examples_for "Acceptance attachable" do
  scenario "Authenticated user attaches file when creates attachable", js: true do
    fill_form

    click_on "Добавить файл"
    all('input[type="File"]')[0].set("#{Rails.root}/spec/spec_helper.rb")
    click_on "Добавить файл"
    all('input[type="File"]')[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on save_button

    expect(page).to have_link "spec_helper.rb"
    expect(page).to have_link "rails_helper.rb"
  end
end
