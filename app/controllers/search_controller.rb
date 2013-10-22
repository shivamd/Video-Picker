class SearchController < ApplicationController

  include SearchHelper

  def youtube
    unless params[:query].match(/(youtu)(be\.com|\.be)/)
      response = get_youtube_videos(params[:query])
      if response && response.videos.present?
        videos = response.videos.map{ |video| format_youtube_response(video) }.compact
        render :json => videos, :status => 200, :query => params[:query]
      else
        render :json => params[:query] ,:status => 404
      end
    else
      video = get_youtube_video(params[:query])
      if video
        video = format_youtube_response(video)
        render json: video, status: 200
      else 
        render status: 404, json: "Couldn't find video"
      end
    end
  end

  def vimeo
    response = get_vimeo_videos(params[:query])
    if response && response["videos"]["video"].present?
      videos = response["videos"]["video"].map { |video| format_vimeo_response(video) }.compact
      render json: videos, status: 200, query: params[:query]
    else
      render json: params[:query], status: 404
    end
  end

  def dailymotion
    response = get_dailymotion_videos(params[:query])
    if response && response["list"].present?
      videos = response["list"].map{ |video| format_dailymotion_response(video) }.compact
      render json: videos, status: 200, query: params[:query]
    else
      render json: params[:query], status: 404
    end
  end

  def popular_vines
    video_links = get_popular_vine_videos(params[:query])
    if video_links.present?
      video_links.map!{ |video| format_vine_response(video) }.compact
      render json: video_links, status: 200, query: params[:query]
    else
      render json: params[:query], status: 404
    end
  end

  def recent_vines
    video_links = get_recent_vine_videos(params[:query])
    if video_links.present?
      video_links.map!{ |video| format_vine_response(video) }.compact
      render json: video_links, status: 200, query: params[:query]
    else
      render json: params[:query], status: 404
    end
  end

  def qwiki
    response = get_qwiki_videos(params[:query])
    if response.present?
      videos = response.map{ |video| format_qwiki_response(video) }.compact
      render json: videos, status: 200, query: params[:query]
    else
      render json: params[:query], status: 404
    end
  end

end
