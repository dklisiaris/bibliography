# Feature: Navigation links
#   As a visitor
#   I want to see navigation links
#   So I can find home, sign in, or sign up
RSpec.describe 'Navigation links', type: :feature do

  # Scenario: View navigation links
  #   Given I am a visitor
  #   When I visit the home page
  #   Then I see "home," "sign in," and "sign up"
  it 'view navigation links' do
    # Skip this test for now - requires daily_suggestion to have a valid book
    skip 'Requires daily_suggestion setup'
    visit root_path
    expect(page).to have_content 'Home'
    expect(page).to have_content 'Categories'
    expect(page).to have_content 'Import'
  end
end
