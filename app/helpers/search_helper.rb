module SearchHelper
	include ActionView::Helpers::DateHelper
	include ActionView::Helpers::NumberHelper

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

end
