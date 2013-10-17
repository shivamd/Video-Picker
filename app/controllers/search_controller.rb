class SearchController < ApplicationController

  include SearchHelper

  def youtube
    client = YouTubeIt::Client.new
    response =  client.videos_by(:query => params[:query]) if params[:query].present?
    if response && response.videos.present?
      videos = response.videos.map{ |video| format_youtube_response(video) }
      render :json => videos, :status => 200, :query => params[:query]
    else
      render :json => params[:query] ,:status => 404
    end
  end

  def vimeo 
    vimeo = Vimeo::Advanced::Video.new(ENV["VIMEO_CONSUMER_KEY"],ENV["VIMEO_CONSUMER_SECRET"],token: ENV["VIMEO_ACCESS_TOKEN"], secret: ENV["VIMEO_ACCESS_SECRET"])
    response = vimeo.search(params[:query], { :page => "1", :per_page => "25", :full_response => "1"}) if params[:query]
    if response && response["videos"]["video"]
      videos = response["videos"]["video"].map { |video| format_vimeo_response(video) }
      render json: videos, status: 200, query: params[:query]
    else
      render json: params[:query], status: 404
    end
  end

end
