require 'rails_helper'

feature 'User can delete answers', %q{
  As an authenticated user
  I'd like to be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }

  describe 'Authenticated user' do

    scenario 'deletes his answer' do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
      question = create_question

      fill_in 'Your answer', with: 'tex tex tex'
      click_on 'Answer'

      click_on 'Delete answer'

      expect(page).to have_content 'Your answer was successfully deleted.'
    end
  end
end