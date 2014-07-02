require_relative '../digg_api'

namespace :digg_api do
	desc "scrape digg and ping database"
	task :run => :environment do
		DiggApi.run
	end
end