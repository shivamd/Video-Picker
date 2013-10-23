class Videopicker.Models.Video extends Backbone.Model
  paramRoot: 'video'

  defaults:
    date: null
    description: null
    duration: null
    image: null
    title: null
    url: null
    user_name: null
    view_count: null

  validate: (attrs) ->
    if !attrs.url
      "cannot have an empty url"

class Videopicker.Collections.VideosCollection extends Backbone.Collection
  model: Videopicker.Models.Video
  url: '/videos'
