module SearchHelper
	include ActionView::Helpers::DateHelper
	include ActionView::Helpers::NumberHelper

  def get_youtube_videos(params)
    query = params[:query]
    page = params[:pages]["youtube"] if params[:pages]
    client = YouTubeIt::Client.new
    begin
      if query.match(/(youtu)(be\.com|\.be)/)
        client.video_by(query)
      else
        response =  client.videos_by(:query => query, :page => page) if query.present?
      end
    rescue
      nil
    end
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
      url: video.player_url,
      source: "youtube"
     }
  end


  def get_vimeo_videos(params)
    query = params[:query]
    page = params[:pages]["vimeo"] if params[:pages]
    vimeo = Vimeo::Advanced::Video.new(ENV["VIMEO_CONSUMER_KEY"],ENV["VIMEO_CONSUMER_SECRET"],token: ENV["VIMEO_ACCESS_TOKEN"], secret: ENV["VIMEO_ACCESS_SECRET"])
    if query.present?
      if query.match(/vimeo\.com/)
        video_id = query.match(/vimeo\.com\/(\w*\/)*(\d+)/)[-1]
        response = Vimeo::Simple::Video.info(video_id).parsed_response
      else
        response = vimeo.search(query, { :page => page || 1, :per_page => "25", :full_response => "1"})
      end
    end
  end

  def format_single_vimeo_response(video)
    {
     image: video["thumbnail_medium"] ,
     duration: video["duration"],
     title: video["title"],
     user_name: video["user_name"],
     date: video["upload_date"],
     view_count: video["stats_number_of_plays"],
     description: video["description"],
     id: video["id"],
     url: video["url"]
    }
  end

  def format_vimeo_response(video)
    {
      image: video["thumbnails"]["thumbnail"][1]["_content"],
      duration: Time.at((video["duration"] ? video["duration"].to_i : 0)).utc.strftime("%H:%M:%S"),
      title: video["title"],
      user_name: video["owner"]["display_name"],
      date: time_ago_in_words(video["upload_date"]),
      view_count: video["number_of_plays"],
      description: video["description"],
      id: video["id"],
      url: video["urls"]["url"][0]["_content"],
      source: "vimeo"
    }
  end

  def get_dailymotion_videos(params)
    query = params[:query]
    page = params[:pages]["dailymotion"] if params[:pages]
    begin
      if query.present?
        fields = "fields=created_time,title,id,description,duration,thumbnail_240_url,owner,url,views_total"
        if query.match(/dailymotion\.com/)
          video_id = query.match(/video\/([^_]+)/)[-1]
          response = open("https://api.dailymotion.com/video/#{video_id}?#{fields}").read
        else
          response = open("https://api.dailymotion.com/videos?search=#{query}&limit=25&#{fields}&page=#{page || 1}").read
        end
        JSON.parse(response)
      end
    rescue
      nil
    end
  end

  def format_dailymotion_response(video)
    {
      image: video["thumbnail_240_url"],
      duration: Time.at((video["duration"] ? video["duration"].to_i : 0)).utc.strftime("%H:%M:%S"),
      title: video["title"],
      user_name: video["owner"],
      date: time_ago_in_words(Time.at(video["created_time"]).utc.to_datetime), #timestamp to time
      view_count: video["views_total"],
      description: video["description"],
      id: video["id"],
      url: video["url"],
      source: "dailymotion"
    }
  end

  def get_popular_vine_videos(params)
    query = params[:query]
    start = params[:pages]["popular_vines"].to_i * 10 if params[:pages]
    begin
      return query.gsub(/http[s]?:\/\//, "") if query.match(/vine\.co/)
      if query.present?
        agent = Mechanize.new
        page = agent.get("https://google.com/search?q=site%3Avine.co%20%23#{query}&start=#{start || 0}")
        page.search('cite').children.map { |i| i.inner_text.gsub(/http[s]?:\/\//, "") }
      end
    rescue
      nil
    end
  end

  def get_recent_vine_videos(query)
    if query.present?
      client = Twitter::Client.new(consumer_key: ENV["TWITTER_CONSUMER_KEY"],consumer_secret: ENV["TWITTER_CONSUMER_SECRET"],access_token: ENV["TWITTER_ACCESS_TOKEN"], access_secret: ENV["TWITTER_ACCESS_SECRET"])
      videos = client.search("vine.co #{query}", count: 25)[:statuses]
      videos = videos.map do |video|
        video_urls = video[:urls]
        if video_urls.present?
          vine_url = video_urls[0][:expanded_url].gsub(/http[s]:\/\//, "")
          vine_url.match(/vine\.co/) ? vine_url : nil
        end
      end
      videos.compact
    end
  end

  def format_vine_response(video)
    begin
      agent = Mechanize.new
      page = agent.get("http://" + video)
      source = page.search('video').select { |i| i.name == "video" }[0].children.select{ |i| i.name == "source" }.first.attributes['src'].value
      thumbnail = page.search('meta[property="og:image"]').first.attributes["content"].value
      title = page.search('meta[property="og:title"]').first.attributes["content"].value
      user_name = page.search("div h2").inner_text

      {
        image: thumbnail,
        duration: nil,
        title: title,
        user_name: user_name,
        date: nil,
        view_count: nil,
        description: nil,
        id: video,
        url: source,
        source: "vine"
      }
    rescue
      nil
    end
  end


  def get_qwiki_videos(params)
    query = params[:query]
    start = params[:pages]["qwiki"].to_i * 10 if params[:pages]
    begin
      if query.present?
        if query.match(/qwiki\.com/)
          format_qwiki_response(query)
        else
          agent = Mechanize.new
          page = agent.get("https://google.com/search?q=site%3Aqwiki.com%20%23#{query}&start=#{start || 0}")
          page.search('cite').children.map { |i| i.inner_text.gsub("https://", "") }
        end
      end
    rescue
      nil
    end
  end

  def format_qwiki_response(video)
    begin
      agent = Mechanize.new
      page = agent.get("http://" + video)
      api_url = page.search('script').to_s.match(/api.+json/)[0]
      api_page = agent.get("http://www.qwiki.com/" +api_url)
      body = JSON.parse(api_page.body)
      source = body["video"]["outputs"].select{ |i| i["type"] == "mp4" }.first["src"]
      title = body["title"]
      description = body["description"]
      user_name = body["user"]["username"]
      date = body["created_at"]
      view_count = body["user"]["qwiki_count"] #not sure if this is the view count
      thumbnail = body["thumbnails"].first["images"].first["src"]

      {
        image: thumbnail,
        duration: nil, #will try and pick this up with phantomjs
        title: title,
        user_name: user_name,
        date: date,
        view_count: view_count,
        description: description,
        id: video,
        url: source,
        source: "qwiki"
      }
    rescue
      nil
    end
  end

  def get_instagram_videos(params)
    query = params[:query]
    page = params[:pages]["instagram"] if params[:pages]
    client_id = ENV["INSTAGRAM_CLIENT_ID"]
    if page
      url = session[:instagram_url]
    else
      url = "https://api.instagram.com/v1/tags/#{query}/media/recent?client_id=#{client_id}"
    end
    if query.present?
      agent = Mechanize.new
      page = agent.get(url)
      session[:instagram_url] = JSON.parse(page.body)["pagination"]["next_url"]
      response = JSON.parse(page.body)["data"]
      response.select{ |media| media["videos"].present? }
    end
  end

  def format_instagram_video(video)
    thumbnail = video["images"]["thumbnail"]["url"]
    duration = nil
    user_name = video["caption"]["from"]["username"] if video["caption"]
    title = "#{user_name}'s video"
    description = video["caption"]["text"] if video["caption"]
    date = time_ago_in_words(DateTime.strptime(video["caption"]["created_time"], "%s")) if video["caption"]
    view_count = video["likes"]["count"]
    source =video["videos"]["standard_resolution"]["url"]
    video = video["link"]
    {
      image: thumbnail,
      duration: nil,
      title: title,
      user_name: user_name,
      date: date,
      view_count: view_count,
      description: description,
      id: video,
      url: source,
      source: "instagram"
    }
  end

end
