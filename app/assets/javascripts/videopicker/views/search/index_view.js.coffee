Videopicker.Views.Search ||= {}

class Videopicker.Views.Search.IndexView extends Backbone.View
  template: JST["videopicker/templates/search/index"]

  className: "search-box"

  initialize: (options) ->
    @sources = options.sources
    @instagramPage = 1

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
    self= @
    e.preventDefault()
    $(".preview").remove()
    $(".results").show()
    self.$(".loader").removeClass "hidden"
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
      data: {query: query, page: 1}
      success: (response, data) ->
        self.$(".loader").addClass "hidden"
        newVideos = []
        _.each(response, (video) ->
          self.video = new Videopicker.Models.Video(video)
          self.videos.add(self.video)
          newVideos.push self.video
        , self)
        self.sortVideos(newVideos)

  sortVideos: (newVideos) ->
    self = @
    videos = _.sortBy(newVideos, (video) ->
      if video.get("view_count")
        if _.isNumber(video.get("view_count"))
          - video.get("view_count")
        else
          - Number(video.get("view_count").replace(/[^0-9\.]+/g,""))
      else
        - 1
    )
    _.each(videos, (video) ->
      view = new Videopicker.Views.Search.VideoView({model: video})
      @$(".results").append(view.render().el)
    , @)
    $(".results").off("scroll").on "scroll", (e) ->
      self.checkVideoScroll(e)

  refreshResults: ->
    _.each(@$(".results .video"), (videoDiv) ->
      source = @$(".source[data-name=" + $(videoDiv).attr("data-source") + "]")
      if source.hasClass("active")
        $(videoDiv).show()
      else
        $(videoDiv).hide()
    , @)

  checkVideoScroll: (e) ->
    elem = $(e.currentTarget)
    pages = {}

    if (elem[0].scrollHeight - elem.scrollTop() == elem.outerHeight()) #and (parseFloat(parseInt(pages["youtube"])) == parseFloat(pages["youtube"]))
      pages["youtube"] = ($('.results .source-youtube').length) / 25 + 1
      pages["vimeo"] = ($('.results .source-vimeo').length) / 25 + 1
      pages["dailymotion"] = ($('.results .source-dailymotion').length) / 25 + 1
      pages["popular_vines"] = ($('.results .source-vine').length)
      pages["qwiki"] = ($('.results .source-qwiki').length)
      pages["instagram"] = @instagramPage += 1
      $(e.currentTarget).off "scroll"
      query = $("input[name='search']").val()
      query_sources = []
      _.each(@$("li"), (filter) ->
        if $(filter).hasClass("active")
          query_sources.push $(filter).attr("data-name")
      )
      @_getMoreVideos(query, query_sources, pages)

  _getMoreVideos: (query, query_sources,pages) ->
    self = @
    self.videos = new Videopicker.Collections.VideosCollection()
    _.each(query_sources, (source) ->
      self._moreVideos(query, source, pages)
    , self)

  _moreVideos: (query, source, pages) ->
    self = @
    query_source = if source == "vine"
      "popular_vines"
    else
      source
    $.ajax
      type: "get"
      url: "/api/search/#{query_source}"
      dataType: 'json'
      data: {query: query, pages: pages}
      success: (response, data) ->
        self.$(".loader").addClass "hidden"
        newVideos = []
        _.each(response, (video) ->
          self.video = new Videopicker.Models.Video(video)
          self.videos.add(self.video)
          newVideos.push self.video
        , self)
        self.sortVideos(newVideos)

