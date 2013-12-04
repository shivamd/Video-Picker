Videopicker.Views.Search ||= {}

class Videopicker.Views.Search.VideoView extends Backbone.View
  template: JST["videopicker/templates/search/video"]

  tagName: "div"
  className: "video"

  events:
    "click img": "showPreview"

  initialize: (options) ->
    @model = options.model

  render: ->
    $(@el).addClass("source-" + (@model.get("source"))).attr "data-source", @model.get("source")
    $(@el).html @template(@model.toJSON())
    @

  showPreview: (e) ->
    $target = $(e.currentTarget)
    source = $target.parent().attr("data-source")
    videoId = $target.attr('data-id')
    url = $target.attr('data-url')
    previewView = new Videopicker.Views.Preview.IndexView({
      videoId: videoId,
      source: source,
      url: url
    })
    $(".search").append(previewView.render().el)
    $(previewView.el).animate(
      marginLeft: "-=99%"
    , 400, ->
      $(".results").hide()
    )
