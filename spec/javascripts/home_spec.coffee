#= require sinon
#= require application

describe "Videopicker routes", ->
  beforeEach ->
    @router = new Videopicker.Routers.SearchRouter()
    @routeSpy = sinon.spy()
    try
      Backbone.history.start
        silent: true
        pushState: true

  it "fires the index route with a blank hash", ->
    @router.bind "route:index", @routeSpy
    @router.navigate "#", true
    expect(@routeSpy.calledOnce).toBeTruthy()
    expect(@routeSpy.calledWith()).toBeTruthy()
    @router.navigate "specs"
