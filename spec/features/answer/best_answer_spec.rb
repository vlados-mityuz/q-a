require 'rails_helper'

feature 'User can set the best answer', %q{
  In order to set it above all other answers
  As an author of question
  I'd like to be able to set the best answer
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, :with_answers, author: author) }

  describe 'Authenticated user', js: :true do

    scenario 'who is an author of the question, chooses the best answer', js: :true do
      sign_in(author)
      visit question_path(question)
      within '.answers' do
        click_on('Best answer', match: :first)
        expect(page).to have_content 'Best answer was chosen'
      end
    end

    scenario 'who isnt the author of the question, tries to choose the best answer' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_link 'Best answer'
      end
    end
  end
  scenario 'Unauthenticated user can edit his answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link 'Best answer'
    end
  end
end