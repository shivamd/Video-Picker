require 'spec_helper'
describe SearchController do

	describe "#youtube" do
		it "should return a 200" do
			get :youtube,  :query => 'test'
			expect(response.status).to eq(200)
		end

		it "should not make a search if query is blank" do
			get :youtube,  :query => ''
			expect(response.status).to eq(404)
		end

		it "should 404 if there are no results" do
			get :youtube,  :query => 'aosuhfsaouf'
			expect(response.status).to eq(404)
		end

		it "should return JSON data" do
			get :youtube,  :query => 'test'
			response.header['Content-Type'].should include 'application/json'
		end
	end

	describe "#vimeo" do
		it "should return a 200" do
			get :vimeo,  :query => 'test'
			expect(response.status).to eq(200)
		end

		it "should not make a search if query is blank" do
			get :vimeo,  :query => ''
			expect(response.status).to eq(404)
		end

		it "should 404 if there are no results" do
			get :vimeo,  :query => 'uaohsuhsdf'
			expect(response.status).to eq(404)
		end

		it "should return JSON data" do
			get :vimeo,  :query => 'test'
			response.header['Content-Type'].should include 'application/json'
		end
	end

end
