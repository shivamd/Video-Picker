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

  describe "#dailymotion" do 
    it "should return a 200" do 
      get :dailymotion, :query => "test"
      expect(response.status).to eq(200)
    end

		it "should not make a search if query is blank" do
			get :dailymotion,  :query => ''
			expect(response.status).to eq(404)
		end

		it "should 404 if there are no results" do
			get :dailymotion,  :query => 'uaohsuhsdf'
			expect(response.status).to eq(404)
		end

		it "should return JSON data" do
			get :dailymotion,  :query => 'test'
			response.header['Content-Type'].should include 'application/json'
		end
  end

  describe "#popular_vines" do 
    it "should return a 200" do 
      get :popular_vines, :query => "test"
      expect(response.status).to eq(200)
    end

		it "should not make a search if query is blank" do
			get :popular_vines,  :query => ''
			expect(response.status).to eq(404)
		end

		it "should 404 if there are no results" do
			get :popular_vines,  :query => 'uaohsuhsdf'
			expect(response.status).to eq(404)
		end

		it "should return JSON data" do
			get :popular_vines,  :query => 'test'
			response.header['Content-Type'].should include 'application/json'
		end
  end
  
  describe "#recent_vines" do 
    it "should return a 200" do 
      get :recent_vines, :query => "test"
      expect(response.status).to eq(200)
    end

		it "should not make a search if query is blank" do
			get :recent_vines,  :query => ''
			expect(response.status).to eq(404)
		end

		it "should 404 if there are no results" do
			get :recent_vines,  :query => 'uaohsuhsdf'
			expect(response.status).to eq(404)
		end

		it "should return JSON data" do
			get :recent_vines,  :query => 'test'
			response.header['Content-Type'].should include 'application/json'
		end
  end

end
