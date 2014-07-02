require_relative '../rails_helper'

# only testing should_ping_api? b/c other methods are trivial
describe DiggApi, "#should_ping_api?" do

	before(:each) do
		# get doc containing product_hunted, with 2 products > 100 votes
		file_location = File.join(File.dirname(__FILE__), '../data/index.html')
		@doc = Nokogiri::HTML(File.read(file_location))
	end

	it "be true if parsing a page with digg > 5000 votes" do
		expect(DiggApi.should_ping_api?(@doc)).to be(true)
	end

	it "be true if parsing a page with digg > 5000 votes and another in db" do
		Digg.where(content_id: "1mRbwtP").first_or_create!

		expect(DiggApi.should_ping_api?(@doc)).to be(true)

		Digg.delete_all
	end

	it "be false if parsing a page where all diggs already in database" do
		# create all Diggs with count over 5000
		Digg.where(content_id: "1xc6Oub").first_or_create!
		Digg.where(content_id: "1mRbwtP").first_or_create!
		Digg.where(content_id: "1ltNBeW").first_or_create!

		expect(DiggApi.should_ping_api?(@doc)).to be(false)

		Digg.delete_all
	end
end