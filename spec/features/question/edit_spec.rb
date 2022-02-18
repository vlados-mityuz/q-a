require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct his mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }

  describe 'Authenticated user edits his question', js: :true do
    background do
      sign_in(author)
      visit question_path(question)

      within '.question' do
        click_on('Edit')
      end
    end

    scenario 'without errors', js: :true do
      within '.question' do
        edited_question = question
        fill_in 'Title', with: 'Edited question'
        fill_in 'Body', with: 'Edited text'
        click_on 'Save'

        expect(page).to_not have_content edited_question.title
        expect(page).to_not have_content edited_question.body
        expect(page).to have_content 'Edited question'
        expect(page).to have_content 'Edited text'
        expect(page).to_not have_selector 'textarea'

        expect(page).to have_content 'Question successfully updated'
      end
    end

    scenario 'with errors', js: :true do
      within '.question' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
      end

      within '.question-errors' do
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Authenticated user tries to edit another users question' do
    sign_in(user)
    visit question_path(question)
    within '.question' do
      expect(page).not_to have_link 'Edit'
    end
  end

  scenario 'Unauthenticated user can edit his answer' do
    visit question_path(question)

    within '.question' do
      expect(page).not_to have_link 'Edit'
    end
  end
end