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
    $(".no-result").hide()
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
    self.searchProgress = 0
    self.$(".results").html("")
    _.each(query_sources, (source) ->
      self._getVideos(query, source, query_sources.length)
    , self)


  _getVideos: (query, source, numberOfRequests) ->
    self = @
    self.source = source
    $.ajax
      type: "get"
      url: "/api/search/videos"
      dataType: 'json'
      data: { query: query, page: 1, sources: source }
      success: (response, data) ->
        newVideos = []
        source = Object.keys(response)[0]
        _.each(response[source], (video) ->
          self.video = new Videopicker.Models.Video(video)
          self.videos.add(self.video)
          newVideos.push self.video
        , self)
        unless newVideos.length == 0
          self.$(".loader").addClass "hidden"
        self.searchProgress += 1
        self.handleEndSearch(numberOfRequests)
        self.sortVideos(newVideos)
        self.sortVideos(newVideos)

  sortVideos: (newVideos) ->
    self = @
    videos = _.sortBy(newVideos, (video) ->
      - video.get("accuracy")
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
    if @scrolledToBottom(e)
      $(e.currentTarget).off "scroll"
      $("img.paginate").removeClass "hidden"
      pageNumbers = @calculatePages()
      pageableSources = @findPageableSources(pageNumbers)
      query = $("input[name='search']").val()
      query_sources = []
      _.each(@$("li"), (filter) ->
        if $(filter).hasClass("active")
          query_sources.push $(filter).attr("data-name")
      )
      query_sources = query_sources.filter (n) ->
          pageableSources.indexOf(n) isnt -1
      @_getMoreVideos(query, query_sources, pageNumbers)

  scrolledToBottom: (e) ->
    elem = $(e.currentTarget)
    elem[0].scrollHeight - elem.scrollTop() == (elem.outerHeight() + 1)

  calculatePages: ->
    pages = {}
    pages["youtube"] = ($('.results .source-youtube').length) / 25 + 1
    pages["vimeo"] = ($('.results .source-vimeo').length) / 25 + 1
    pages["dailymotion"] = ($('.results .source-dailymotion').length) / 25 + 1
    pages["popular_vines"] = ($('.results .source-vine').length) / 10
    pages["qwiki"] = ($('.results .source-qwiki').length) / 10
    pages["instagram"] = @instagramPage += 1

    pages

  findPageableSources: (pages) ->
    self = @
    sources = ["youtube", "vimeo", "dailymotion", "popular_vines", "qwiki", "instagram"]
    sources.map (source) -> self.isPageable(source, pages)

  isPageable: (source,pages) ->
    if (parseFloat(parseInt(pages[source])) == parseFloat(pages[source]))
      if source is "popular_vines" then "vine" else source

  _getMoreVideos: (query, query_sources,pages) ->
    self = @
    self.videos = new Videopicker.Collections.VideosCollection()
    _.each(query_sources, (source) ->
      self._moreVideos(query, source, pages)
    , self)

  _moreVideos: (query, source, pages) ->
    self = @
    self.source = source
    $.ajax
      type: "get"
      url: "/api/search/videos"
      dataType: 'json'
      data: {query: query, pages: pages, sources: source }
      success: (response, data) ->
        self.$(".loader").addClass "hidden"
        newVideos = []
        source = Object.keys(response)[0]
        _.each(response[source], (video) ->
          self.video = new Videopicker.Models.Video(video)
          self.videos.add(self.video)
          newVideos.push self.video
        , self)
        self.sortVideos(newVideos)
        $("img.paginate").addClass "hidden"

  handleEndSearch: (numberOfRequests) ->
    self = @
    if numberOfRequests == self.searchProgress && self.videos.isEmpty?
      $(".loader").addClass "hidden"
      $(".no-result").show()

