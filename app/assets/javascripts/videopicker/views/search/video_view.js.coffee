Videopicker.Views.Search ||= {}

class Videopicker.Views.Search.VideoView extends Backbone.View
  template: JST["videopicker/templates/search/video"]

  tagName: "div"
  className: "video"

  initialize: (options) ->
    @model = options.model

  render: =>
    $(@el).addClass("source-#{@model.get('source')}")
    $(@el).html(@template(@model.toJSON()))
    @
