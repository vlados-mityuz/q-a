require 'rails_helper'

feature 'User can sign out', %q{
  In order to end his session
} do

  given(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'Registered user tries to sign out' do
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end