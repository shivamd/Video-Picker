Videopicker.Views.Search ||= {}

class Videopicker.Views.Search.IndexView extends Backbone.View
  template: JST["videopicker/templates/search/index"]

  className: "search-box"

  initialize: (options) ->
    @sources = options.sources

  events:
    "click .source" : "manageSource"
    "dblclick .source" : "isolateSource"
    "click input[type='submit']" : "launchSearch"

  render: =>
    $(@el).html(@template({@sources}))
    @

  manageSource: (e) ->
    filter = $(e.target).closest("li")
    if filter.hasClass "active"
      filter.removeClass "active"
      filter.addClass "inactive"
    else
      filter.removeClass "inactive"
      filter.addClass "active"
    @refreshResults()

  isolateSource: (e) ->
    @$("li").removeClass "active"
    @$("li").addClass "inactive"
    $(e.target).removeClass "inactive"
    $(e.target).addClass "active"
    if window.getSelection
      window.getSelection().removeAllRanges()
    else if document.selection
      document.selection.empty()
    @refreshResults()

  launchSearch: (e) ->
    e.preventDefault()
    $(".preview").remove()
    $(".results").show()
    query = $("input[name='search']").val()
    query_sources = []
    _.each(@$("li"), (filter) ->
      if $(filter).hasClass("active")
        query_sources.push $(filter).attr("data-name")
    )
    @_getAllVideos(query, query_sources)

  _getAllVideos: (query, query_sources) ->
    self = @
    self.videos = new Videopicker.Collections.VideosCollection()
    self.$(".results").html("")
    _.each(query_sources, (source) ->
      self._getVideos(query, source)
    , self)

  _getVideos: (query, source) ->
    self = @
    query_source = if source == "vine"
      "popular_vines"
    else
      source
    $.ajax
      type: "get"
      url: "/api/search/#{query_source}"
      dataType: 'json'
      data: {query: query}
      success: (response, data) ->
        newVideos = []
        _.each(response, (video) ->
          self.video = new Videopicker.Models.Video(video)
          self.videos.add(self.video)
          newVideos.push self.video
        , self)
        self.sortVideos(newVideos)

  sortVideos: (newVideos) ->
    videos = _.sortBy(newVideos, (video) ->
      - video.get("accuracy")
    )
    _.each(videos, (video) ->
      view = new Videopicker.Views.Search.VideoView({model: video})
      @$(".results").append(view.render().el)
    , @)

  refreshResults: ->
    _.each(@$(".results .video"), (videoDiv) ->
      source = @$(".source[data-name=" + $(videoDiv).attr("data-source") + "]")
      if source.hasClass("active")
        $(videoDiv).show()
      else
        $(videoDiv).hide()
    , @)

