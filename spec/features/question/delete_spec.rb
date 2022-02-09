require 'rails_helper'

feature 'User can delete question', %q{
  As an authenticated user
  I'd like to be able to delete my question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    scenario 'deletes his question' do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
      create_question    

      click_on 'Delete question'

      expect(page).to have_content 'Your question was successfully deleted.'
    end
  end
end