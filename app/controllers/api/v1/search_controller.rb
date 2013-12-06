module Api
  module V1
    class SearchController < ApplicationController
      before_filter :restrict_access

      include SearchHelper

      def youtube
        response = get_youtube_videos(params)
        if response
          videos = response.videos.map{ |video| format_youtube_response(video, params[:query]) }.compact
          render json: videos, status: 200, query: params[:query] and return
        end
        render json: { query: params[:query], error: "Couldn't find video" } , status: 404
      end

      def vimeo
        query = params[:query]
        response = get_vimeo_videos(params)
        if response
          videos = response["videos"]["video"].map { |video| format_vimeo_response(video, params[:query]) }.compact
          render json: videos, status: 200, query: query and return
        end
        render json: { query: query, error: "Couldn't find video" }, status: 404
      end

      def dailymotion
        response = get_dailymotion_videos(params)
        if response
          videos = response["list"].map{ |video| format_dailymotion_response(video, params[:query]) }.compact
          render json: videos, status: 200, query: params[:query] and return
        end
        render json: { query: params[:query], error: "Couldn't find video"}, status: 404
      end

      def popular_vines
        video_links = get_popular_vine_videos(params)
        if video_links.present?
          video_links.map!{ |video| format_vine_response(video, params[:query]) }.compact
          render json: video_links, status: 200, query: params[:query] and return
        end
        render json: { query: params[:query], error: "Couldn't find video" }, status: 404
      end

      def recent_vines
        video_links = get_recent_vine_videos(params[:query])
        if video_links.present?
          video_links.map!{ |video| format_vine_response(video, params[:query]) }.compact
          render json: video_links, status: 200, query: params[:query] and return
        end
        render json: { query: params[:query], error: "Couldn't find video" }, status: 404
      end

      def qwiki
        response = get_qwiki_videos(params)
        if response.present?
          videos = response.map{ |video| format_qwiki_response(video, params[:query]) }.compact
          render json: videos, status: 200, query: params[:query] and return
        end
        render json: { query: params[:query], error: "Couldn't find video" }, status: 404
      end

      def instagram
        videos = get_instagram_videos(params)
        if response.present?
          videos = videos.map { |video| format_instagram_video(video, params[:query]) }.compact
          render json: videos, status: 200, query: params[:query] and return
        end
        render json: { query: params[:query], error: "Couldn't find video" }, status: 404
      end

      private

      def restrict_access
        app = Application.find_by_access_token(params[:access_token])
        head :unauthorized unless app || session[:user].present?
      end

    end
  end
end
