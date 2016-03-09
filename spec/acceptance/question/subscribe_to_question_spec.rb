require_relative '../acceptance_helper'

feature 'subscribe to question', '
  In order to receive notification about new answers
  As user
  I want to be able to subscribe to question
' do
  given(:user) { create(:user) }
  given!(:question) { create :question }

  scenario 'user subscribes to question', js: true do
    sign_in user
    visit question_path(question)
    click_on 'Подписаться'

    expect(page).to have_content 'Вы успешно подписались на вопрос'
    expect(page).to_not have_link 'Подписаться'
    expect(page).to have_link 'Отписаться'
  end

  scenario 'guest cant see button' do
    visit question_path(question)

    expect(page).to_not have_link 'Подписаться'
  end
end