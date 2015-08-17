require 'test_helper'

class UserAddsEntryTest < ActionDispatch::IntegrationTest
  
  test "user should be able to add entry" do    	     
    visit('urls#index')
    click_link('New Url')
    fill_in('url_url_short', :with => 'test1')
    fill_in('url_url_long', :with => 'https://github.com/jnicklas/capybara')
    click_button('Create Url')
    click_link('Back')
    page.assert_text('http://www.example.com/test1')
    page.assert_text('https://github.com/jnicklas/capybara')
  end

end
