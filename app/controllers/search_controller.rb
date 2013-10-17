class SearchController < ApplicationController
 
  include SearchHelper

  def youtube
    client = YouTubeIt::Client.new
    response =  client.videos_by(:query => params[:query])
    if response.videos.present?
      videos = response.videos.map{ |video| format_youtube_response(video) }
      render :json => videos, :status => 200, :query => params[:query]
    else
      render :json => params[:query] ,:status => 404
    end
  end

end
