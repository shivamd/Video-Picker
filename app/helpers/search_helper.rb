module SearchHelper
	include ActionView::Helpers::DateHelper
	include ActionView::Helpers::NumberHelper

  def get_youtube_videos(query)
    client = YouTubeIt::Client.new
    response =  client.videos_by(:query => query) if query.present?
  end

  def format_youtube_response(video)
    {
      image: video.thumbnails[1].url,
      duration: Time.at(video.duration).utc.strftime("%H:%M:%S"),
      title: video.title,
      user_name: video.author.name,
      date: time_ago_in_words(video.published_at),
      view_count: number_with_delimiter(video.view_count, :delimiter => ','),
      description: video.description,
      id: video.video_id.match(/video:(.+)/)[1],
      url: video.player_url
     }
  end

  def get_vimeo_videos(query)
    vimeo = Vimeo::Advanced::Video.new(ENV["VIMEO_CONSUMER_KEY"],ENV["VIMEO_CONSUMER_SECRET"],token: ENV["VIMEO_ACCESS_TOKEN"], secret: ENV["VIMEO_ACCESS_SECRET"])
    response = vimeo.search(query, { :page => "1", :per_page => "25", :full_response => "1"}) if query.present?
  end

  def format_vimeo_response(video)
    {
      image: video["thumbnails"]["thumbnail"][1]["_content"],
      duration: video["duration"],
      title: video["title"],
      user_name: video["owner"]["display_name"],
      date: time_ago_in_words(video["upload_date"]),
      view_count: video["number_of_plays"],
      description: video["description"],
      id: video["id"],
      url: video["urls"]["url"][0]["_content"]
    }
  end

  def get_dailymotion_videos(query)
    if query.present?
      response = open("https://api.dailymotion.com/videos?search=#{query}&limit=25&fields=created_time,title,id,description,duration,thumbnail_240_url,owner,url,views_total").read
      JSON.parse(response)
    end
  end

  def format_dailymotion_response(video)
    {
      image: video["thumbnail_240_url"],
      duration: video["duration"],
      title: video["title"],
      user_name: video["owner"],
      date: time_ago_in_words(Time.at(video["created_time"]).utc.to_datetime), #timestamp to time 
      view_count: video["views_total"],
      description: video["description"],
      id: video["id"],
      url: video["url"]
    }
  end

end
