require 'open-uri'
require 'net/http'

# Scrapes Digg and pings the Yo api if necessary
#
# @example
#
#     require 'digg_api'
#
#     DiggApi.run
class DiggApi

	NUM_VOTES = 20000 # if diggs > NUM_VOTES, will ping
	API_TOKEN = ENV["DIGG_API_TOKEN"]
	API_ENDPOINT = "http://api.justyo.co/yoall/"

	# check if should ping, and if should ping, do it
	def self.run
		doc = Nokogiri::HTML(open("http://www.digg.com"))

		if self.should_ping_api?(doc)
			self.ping_api
		end
	end

	# parse digg to see if should ping
	#
	# doc - the Nokogiri document
	def self.should_ping_api?(doc)
		# get all diggs
		diggs = doc.css('article.story-container')

		diggs.each do |d|
			if d['data-digg-score'].sub(",", "").to_i > NUM_VOTES # b/c if , messes up
				content_id = d['data-content-id']
				if Digg.find_by(content_id: content_id).nil?
					Digg.create!(content_id: content_id)

					return true # so don't add other products
				end
			end
		end

		return false
	end

	# ping the api
	def self.ping_api
		uri = URI(API_ENDPOINT)
		Net::HTTP.post_form(uri, 'api_token' => API_TOKEN)
	end

end
