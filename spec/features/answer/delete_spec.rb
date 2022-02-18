require 'rails_helper'

feature 'User can delete answers', %q{
  As an authenticated user
  I'd like to be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, :with_answers, author: author) }

  scenario "authenticated user tries to delete own answer", js: true do
    sign_in(author)
    visit question_path(question)

    del_answer = question.answers.first.body

    expect(page).to have_content del_answer

    click_on("Delete answer", match: :first)

    expect(page).to have_content 'Answer successfully deleted'

    expect(page).not_to have_content del_answer
  end

  scenario "authenticated user tries to delete someone's answer", js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).not_to have_link 'Delete answer'
  end

  scenario "unauthenticated user tries to delete answer", js: true do
    visit question_path(question)

    expect(page).not_to have_link 'Delete answer'
  end
end