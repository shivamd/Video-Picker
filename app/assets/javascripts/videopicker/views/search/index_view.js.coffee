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

    return @

  manageSource: (e) ->
    filter = $(e.target)
    if filter.hasClass "active"
      filter.removeClass "active"
      filter.addClass "inactive"
    else
      filter.removeClass "inactive"
      filter.addClass "active"

  isolateSource: (e) ->
    $("li").removeClass "active"
    $("li").addClass "inactive"
    $(e.target).removeClass "inactive"
    $(e.target).addClass "active"
    if window.getSelection
      window.getSelection().removeAllRanges()
    else if document.selection
      document.selection.empty()

  launchSearch: (e) ->
    e.preventDefault()
    query = $("input[name='search']").val()
    query_sources = []
    _.each($("li"), (filter) ->
      if $(filter).hasClass("active")
        query_sources.push $(filter).attr("data-name")
    )
    @_getAllVideos(query, query_sources)

  _getAllVideos: (query, query_sources) ->
    self = @
    _.each(query_sources, (source) ->
      self._getVideos(query, source)
    )

  _getVideos: (query, source) ->
    $.ajax
      type: "get"
      url: "/search/#{source}"
      dataType: 'json'
      data: {query: query}
      success: (response) ->
        console.log(response)
