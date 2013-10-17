class SearchController < ApplicationController

  include SearchHelper

  def youtube
    response = get_youtube_videos(params[:query])
    if response && response.videos.present?
      videos = response.videos.map{ |video| format_youtube_response(video) }
      render :json => videos, :status => 200, :query => params[:query]
    else
      render :json => params[:query] ,:status => 404
    end
  end

  def vimeo
    response = get_vimeo_videos(params[:query])
    if response && response["videos"]["video"].present?
      videos = response["videos"]["video"].map { |video| format_vimeo_response(video) }
      render json: videos, status: 200, query: params[:query]
    else
      render json: params[:query], status: 404
    end
  end

end
