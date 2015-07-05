require 'test_helper'

class UserRedirectTest < ActionDispatch::IntegrationTest
  	def setup
		@url = urls(:one)
		@url_dup = urls(:two)
	end

	# when the shorten url is valid
	test "user should be redirected to requested page" do
		@url.save
		get 'http://localhost:3000/NGVmOWYwODNh'
		assert_redirected_to 'https://github.com/alexanderzerz/url_shortener'
	end

	# when the shorten url is invalid
	test "user should be redirected to index page" do
		@url.save
		get 'http://localhost:3000/NGVmOWYwODNh----'
		assert_redirected_to controller: "urls", action: "index"
	end

end
