class Videopicker.Routers.SearchRouter extends Backbone.Router

  routes:
    ".*" : "index"

  index: ->
    @view = new Videopicker.Views.Search.IndexView()
    $(".container").html(@view.render().el)

