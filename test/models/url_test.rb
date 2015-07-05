require 'test_helper'

class UrlTest < ActiveSupport::TestCase
	def setup
		@url = urls(:one)
		@url_dup = urls(:two)
	end

	test "url should be valid" do
		assert @url.valid?
	end

	test "url should be present" do
		@url.url_long = " "
		assert_not @url.valid?
	end

	# AZ27062015: Test URL's from https://mathiasbynens.be/demo/url-regex
	test "url validation should accept addresses" do
		valid_addresses = %w(http://foo.com/blah_blah http://foo.com/blah_blah/ http://foo.com/blah_blah_(wikipedia) 	
							http://foo.com/blah_blah_(wikipedia)_(again) http://www.example.com/wpstyle/?p=364 	
							https://www.example.com/foo/?bar=baz&inga=42&quux http://df.ws/123 	
							http://userid:password@example.com:8080 http://userid:password@example.com:8080/ 	
							http://userid@example.com http://userid@example.com/ 	
							http://userid@example.com:8080 http://userid@example.com:8080/ 	
							http://userid:password@example.com http://userid:password@example.com/ 	
							http://142.42.1.1/ http://142.42.1.1:8080/ 		
							http://foo.com/blah_(wikipedia)#cite-1 http://foo.com/blah_(wikipedia)_blah#cite-1 	
							http://foo.com/(something)?after=parens http://code.google.com/events/#&product=browser 	
							http://j.mp ftp://foo.bar/baz 	
							http://foo.bar/?q=Test%20URL-encoded%20stuff http://1337.net 	
							http://a.b-c.de http://223.255.255.254)

		valid_addresses.each do |valid_address|
			@url.url_long = valid_address
			assert @url.valid?, "#{valid_address.inspect} should be valid"
		end
	end

	test "url validation should reject addresses" do
		invalid_addresses = ['www.example.com', 'example.com',
                    		 'example example']
		invalid_addresses.each do |invalid_address|
			@url.url_long = invalid_address
			assert_not @url.valid?, "#{invalid_address.inspect}, should be invalid"
		end
	end

	test "url should be unique" do
		@url.save
		assert_not @url_dup.valid?
	end

	test "shorten url should be calculated proper" do
		@url.save
		assert_equal(@url.url_short, 'NGVmOWYwODNh')
	end
end
