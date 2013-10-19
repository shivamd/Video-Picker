class Videopicker.Routers.SearchRouter extends Backbone.Router

  routes:
    ".*" : "index"

  index: ->
    @view = new Videopicker.Views.Search.IndexView({sources: ["youtube", "vimeo", "dailymotion", "vine", "instagram", "qwiki"]})
    $(".container").html(@view.render().el)

