shared_examples_for 'Acceptance commentable' do
  scenario 'Authenticated user adds comment to commentable', js: true do
    sign_in user

    visit question_path(question)
    within selector do
      click_on 'Комментировать'
      fill_in 'Body', with: 'new comment'
      click_on 'Сохранить'

      expect(page).to_not have_selector 'textarea'
      expect(page).to have_content 'new comment'
    end
  end

  scenario 'Non authenticated user cannot see comment button' do
    visit question_path(question)
    within selector do
      expect(page).to_not have_link 'Комментировать'
    end
  end
end
