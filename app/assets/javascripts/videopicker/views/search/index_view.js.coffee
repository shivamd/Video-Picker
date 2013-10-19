Videopicker.Views.Search ||= {}

class Videopicker.Views.Search.IndexView extends Backbone.View
  template: JST["videopicker/templates/search/index"]

  className: "search-box"

  initialize: (options) ->
    @sources = options.sources

  events:
    "click .source" : "manageSource"

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

