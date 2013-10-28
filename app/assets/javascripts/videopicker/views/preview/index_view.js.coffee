Videopicker.Views.Preview ||= {}

class Videopicker.Views.Preview.IndexView extends Backbone.View
  template: JST["videopicker/templates/providers/options"]

  className: "preview"

  events:
    "click .back" : "cancel"

  initialize: (options) ->
    @videoId = options.videoId
    @source = options.source

  render: =>
    $(@el).html(@template({@videoId}))
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
