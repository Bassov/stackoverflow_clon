# frozen_string_literal: true

shared_examples_for "Acceptance votable" do
  describe "Authenticated user", js: true do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario "User votes up" do
      within selector do
        click_on "+"

        within(".rating") do
          expect(page).to have_content "1"
        end
      end
    end

    scenario "User votes down" do
      within selector do
        click_on "-"

        within(".rating") do
          expect(page).to have_content "-1"
        end
      end
    end

    scenario "If user votes second time it rejects previous vote" do
      within selector do
        click_on "+"
        sleep(1)
        click_on "+"

        within(".rating") do
          expect(page).to have_content "0"
        end
      end
    end

    scenario "User can re-vote" do
      within selector do
        click_on "+"

        within(".rating") do
          expect(page).to have_content "1"
        end

        click_on "+"

        within(".rating") do
          expect(page).to have_content "0"
        end

        click_on "-"

        within(".rating") do
          expect(page).to have_content "-1"
        end
      end
    end
  end

  scenario "Non-authenticated user cant see vote buttons" do
    visit question_path(question)

    expect(page).to_not have_content "+"
    expect(page).to_not have_content "-"
  end
end
