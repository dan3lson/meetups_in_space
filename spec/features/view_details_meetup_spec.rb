require 'spec_helper'

feature "User views a specific Meetup page" do
  scenario "user sees the correct title" do
    visit '/'
    click_on 'name'

    expect(page).to have_content "Meetup Title"
  end
end
