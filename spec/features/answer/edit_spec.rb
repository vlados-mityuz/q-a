require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct his mistakes
  As an author of answers
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, :with_answers, author: author) }

  describe 'Authenticated user edits his asnwers', js: :true do
    background do
      sign_in(author)
      visit question_path(question)

      @editable_answer = question.answers.first.body

      click_on('Edit', match: :first)
    end

    scenario 'without errors', js: :true do
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content @editable_answer
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'with errors', js: :true do
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content @editable_answer
        expect(page).to have_selector 'textarea'
      end

      within '.answer-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Authenticated user tries to edit another users answer' do
    sign_in(user)
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  scenario 'Unauthenticated user can edit his answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end