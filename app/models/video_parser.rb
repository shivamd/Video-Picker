class VideoParser
  include SearchHelper
  SOURCES = %w(
    youtube
    vimeo
    dailymotion
    vine
    instagram
    qwiki
  )

  def initialize(options)
    @params = options
    @query = options[:query]
    @sources = sanitize_sources
  end

  def parse
    if @sources.present?
      filter_videos
    else
      all_videos
    end
  end

  def filter_videos
    videos = {}
    @sources.each do |source|
      videos[source.to_sym] = send(source)
    end
    videos[:pagination][:next] = pagination_url.html_safe if videos[:pagination]
    videos
  end

  def all_videos
    {
      youtube: youtube,
      vimeo: vimeo,
      dailymotion: dailymotion,
      vine: vine,
      instagram: instagram,
      qwiki: qwiki,
      pagination: {
        next: pagination_url.html_safe
      }
    }
  end

  def pagination_url
    if @sources.present?
      "/api/search/videos?query=#{@query}&sources=#{@sources}&#{pages_query}&access_token=#{@params['access_token']}"
    else
      "/api/search/videos?query=#{@query}&#{pages_query}&access_token=#{@params['access_token']}"
    end
  end

  def pages_query
    calculate_pages.gsub("[", "%5b").gsub("]", "%5d")
  end

  def calculate_pages
    youtube = @youtube_details.count/25 + 1 if @youtube_details
    vimeo = @vimeo_details.count/25 + 1 if @vimeo_details
    dailymotion = @dailymotion_details.count/25 + 1 if @dailymotion_details
    vine = @vine_details.count/10 if @vine_details
    "pages[youtube]=#{youtube}&pages[vimeo]=#{vimeo}&pages[dailymotion]=#{dailymotion}&=pages[vine]=#{vine}"
  end

  def youtube
    response = get_youtube_videos(@params)
    if response
      @youtube_details = response.videos.map{ |video| format_youtube_response(video, @query) }.compact
    end
  end

  def vimeo
    response = get_vimeo_videos(@params)
    if response
     @vimeo_details = response["videos"]["video"].map { |video| format_vimeo_response(video, @query) }.compact
    end
  end

  def dailymotion
    response = get_dailymotion_videos(@params)
    if response
      @dailymotion_details = response["list"].map{ |video| format_dailymotion_response(video, @query) }.compact
    end
  end

  def vine
    video_links = get_popular_vine_videos(@params)
    if video_links.present?
      @vine_details = video_links.map!{ |video| format_vine_response(video, @query) }.compact
    end
  end

  def qwiki
    response = get_qwiki_videos(@params)
    if response.present?
      @qwiki_details = response.map{ |video| format_qwiki_response(video, @query) }.compact
    end
  end

  def instagram
    videos = get_instagram_videos(@params)
    if videos.present?
      @instagram_details = videos.map { |video| format_instagram_video(video, @query) }.compact
    end
  end

  private

    def sanitize_sources
      @params[:sources].split(",").select{ |source| SOURCES.include?(source) } if @params[:sources]
    end
end
