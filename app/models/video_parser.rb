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
    videos
  end

  def all_videos
    {
      youtube: youtube,
      vimeo: vimeo,
      dailymotion: dailymotion,
      vine: vine,
      instagram: instagram,
      qwiki: qwiki
    }
  end

  def youtube
    response = get_youtube_videos(@params)
    if response
      response.videos.map{ |video| format_youtube_response(video, @query) }.compact
    end
  end

  def vimeo
    response = get_vimeo_videos(@params)
    if response
     response["videos"]["video"].map { |video| format_vimeo_response(video, @query) }.compact
    end
  end

  def dailymotion
    response = get_dailymotion_videos(@params)
    if response
      response["list"].map{ |video| format_dailymotion_response(video, @query) }.compact
    end
  end

  def vine
    video_links = get_popular_vine_videos(@params)
    if video_links.present?
      video_links.map!{ |video| format_vine_response(video, @query) }.compact
    end
  end

  def qwiki
    response = get_qwiki_videos(@params)
    if response.present?
      response.map{ |video| format_qwiki_response(video, @query) }.compact
    end
  end

  def instagram
    videos = get_instagram_videos(@params)
    if videos.present?
      videos.map { |video| format_instagram_video(video, @query) }.compact
    end
  end

  private

    def sanitize_sources
      @params[:sources].select{ |source| SOURCES.include?(source) } if @params[:sources]
    end
end
