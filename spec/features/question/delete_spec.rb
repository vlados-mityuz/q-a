require 'rails_helper'

feature 'User can delete question', %q{
  As an authenticated user
  I'd like to be able to delete my question
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }

  scenario "authenticated user tries to delete own question" do
    sign_in(author)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    click_on 'Delete question'

    expect(page).to have_content 'Your question was successfully deleted.'

    expect(page).not_to have_content question.title
    expect(page).not_to have_content question.body
  end

  scenario "authenticated user tries to delete someone's question" do
    sign_in(user)
    visit question_path(question)

    expect(page).not_to have_link 'Delete question'
  end

  scenario "unauthenticated user tries to delete question" do
    visit question_path(question)

    expect(page).not_to have_link 'Delete question'
  end
end