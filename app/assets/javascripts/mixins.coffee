_.mixin(
  capitalize: (string) ->
    return string.charAt(0).toUpperCase() + string.substring(1).toLowerCase()
)
