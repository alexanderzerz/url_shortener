require 'uri'
require 'digest'

class Url < ActiveRecord::Base	
	attr_accessor :url_host
	
	# AZ27062015: using build in functions to test for:
	# 	- input url not empty
	# 	- url is valid		
	validates :url_long, presence: true , format: { with: URI.regexp(['https', 'http', 'ftp']) }
	
	validate :url_already_exist
	
	before_save :map_url_short	

	# AZ27062015: if the long url already existst, the corresponding short url will be
	#  returned as warning.
	def url_already_exist
		if create_url_short() == true
			errors.add(:warning, "shorten URL already exist \"#{url_host}#{@temp_url_short}\"")
		end
	end

	def map_url_short
		self.url_short =  @temp_url_short
	end

	# AZ27062015: the reason for this implentation
	# 				- no additional gem
	# 				- unique "short-url"
	# 				- use general algorithm for url generation
	# Methode calculates shorten url based on MD5 hashing and Base64 encoding.
	# If the shorten url and original url already exist in the DB no new record
	#  will be createt.
	# Otherwise the procedure runs until a new short url is createt.
	def create_url_short
		
		temp_url_long = self.url_long
		url_exist = false
		
		loop do
			@temp_url_short = Digest::MD5.hexdigest(temp_url_long)[0..8]
			@temp_url_short = Base64::encode64(@temp_url_short).chomp

			temp_record = Url.find_by(url_short: @temp_url_short)
			
			if temp_record == nil
				break
			elsif temp_record["url_long"] == self.url_long
				url_exist = true
				break
			else
				temp_url_long += "-"
			end				
		end
		return url_exist		
	end
end
