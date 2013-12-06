module Api
  module V1
    class SearchController < ApplicationController
      before_filter :restrict_access

      def videos
        if videos = VideoParser.new(params).parse
          render json: videos, status: 200, query: params[:query]
        else
          render json: { query: params[:query], error: "Couldn't find video" }, status: 404
        end
      end

      private

      def restrict_access
        app = Application.find_by_access_token(params[:access_token])
        head :unauthorized unless app || session[:user].present?
      end

    end
  end
end
