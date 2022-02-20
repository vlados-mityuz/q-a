require 'rails_helper'

feature 'User can delete attachments', %q{
  As an author
  I'd like to be able to delete an attachment
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, :with_file, author: author) }
  given!(:answer) { create(:answer, :with_file, question: question, author: author) }

  scenario "authenticated user tries to delete attachment of his own question", js: true do
    sign_in(author)
    visit question_path(question)

    within '.question' do
      expect(page).to have_content 'rails_helper.rb'

      click_on("Delete file")

      visit question_path(question)

      expect(page).not_to have_content 'rails_helper.rb'
    end
  end

  scenario "authenticated user tries to delete attachment of his own answer", js: true do
    sign_in(author)
    visit question_path(question)

    within '.answers' do
      expect(page).to have_content 'rails_helper.rb'

      click_on("Delete file")

      visit question_path(question)

      expect(page).not_to have_content 'rails_helper.rb'
    end
  end

  scenario "authenticated user tries to delete attachment of someone's question", js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      expect(page).not_to have_link 'Delete file'
    end
  end

  scenario "authenticated user tries to delete attachment of someone's answer", js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link 'Delete file'
    end
  end

  scenario "unauthenticated user tries to delete attachment of question", js: true do
    visit question_path(question)

    within '.question' do
      expect(page).not_to have_link 'Delete file'
    end
  end

  scenario "unauthenticated user tries to delete attachment of answer", js: true do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link 'Delete file'
    end
  end
end