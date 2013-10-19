Videopicker.Views.Search ||= {}

class Videopicker.Views.Search.IndexView extends Backbone.View
  template: JST["videopicker/templates/search/index"]

  className: "search-box"

  initialize: (options) ->
    @sources = options.sources

  events:
    "click .source" : "manageSource"
    "dblclick .source" : "isolateSource"

  render: =>
    $(@el).html(@template({@sources}))

    return @

  manageSource: (e) ->
    if $(e.target).hasClass "active"
      $(e.target).removeClass "active"
      $(e.target).addClass "inactive"
    else
      $(e.target).removeClass "inactive"
      $(e.target).addClass "active"

  isolateSource: (e) ->
    $("li").removeClass "active"
    $("li").addClass "inactive"
    $(e.target).removeClass "inactive"
    $(e.target).addClass "active"
    if window.getSelection
      window.getSelection().removeAllRanges()
    else if document.selection
      document.selection.empty()

