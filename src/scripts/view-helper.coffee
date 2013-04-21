Handlebars = require 'handlebars'
Chaplin = require 'chaplin'

Handlebars.registerHelper 'url', (routeName, params..., options) ->
  Chaplin.helpers.reverse routeName, params

Handlebars.registerHelper 'get', ( path, params... ) ->
  chain = path.split '/'
  model = @
  for name in chain
    model = model.get name
    return null unless model?
  return model.toString(params...)