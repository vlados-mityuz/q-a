require 'rails_helper'

feature 'User can answer questions in order', %q{
  To help other people
  As an authenticated user
  I'd like to be able to answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user ) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'gives an answer' do
      fill_in 'Your answer', with: 'tex tex tex'
      click_on 'Answer'

      expect(page).to have_content 'Answer was successfully created'
      expect(page).to have_content 'tex tex tex'
    end
    
    scenario 'gives an answer with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'  
  end
end