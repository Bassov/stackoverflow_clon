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

  describe 'Authenticated user', js: true do
    before { sign_in user }

    scenario 'User votes up for answer' do
      visit question_path(question)
      within("#answer_#{answer.id}") do
        click_on '+'

        within('.rating') do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'User votes down for answer' do
      visit question_path(question)
      within("#answer_#{answer.id}") do
        click_on '-'

        within('.rating') do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'Author of answer cant create for own answer' do
      visit question_path(question)
      within("#answer_#{user_answer.id}") do
        expect(page).to_not have_content '+'
        expect(page).to_not have_content '-'
      end
    end

    scenario 'If user votes second time it rejects previous create' do
      visit question_path(question)
      within("#answer_#{answer.id}") do
        click_on '+'
        sleep(1)
        click_on '+'

        within('.rating') do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'User can re-create for answer' do
      visit question_path(question)
      within("#answer_#{answer.id}") do
        click_on '+'

        within('.rating') do
          expect(page).to have_content '1'
        end

        click_on '+'

        within('.rating') do
          expect(page).to have_content '0'
        end

        click_on '-'

        within('.rating') do
          expect(page).to have_content '-1'
        end
      end
    end
  end

  scenario 'Non-authenticated user cant see create buttons' do
    visit question_path(question)

    expect(page).to_not have_content '+'
    expect(page).to_not have_content '-'
  end
end
