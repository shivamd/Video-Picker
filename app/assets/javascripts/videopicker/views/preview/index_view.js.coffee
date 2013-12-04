Videopicker.Views.Preview ||= {}

class Videopicker.Views.Preview.IndexView extends Backbone.View
  template: JST["videopicker/templates/providers/options"]

  className: "preview"

  events:
    "click .back" : "cancel"
    "click .get_url" : "geturl"

  initialize: (options) ->
    @videoId = options.videoId
    @source = options.source
    @url = options.url

  render: =>
    $(@el).html(@template({videoId: @videoId, url: @url}))
    @renderSource(@videoId, @source)
    @

  renderSource: (videoId, source) ->
  	previewTemplate = JST["videopicker/templates/providers/#{source}"]
  	$(@el).prepend(previewTemplate({videoId: videoId}))

  cancel: ->
    $(".results").show()
    $(@el).animate(
      marginLeft: "+=450px"
    , 700, ->
      @remove()
    )

  geturl: ->
    @$(".url").stop().toggle( "blind", 500 )

