Handlebars = require 'handlebars'
Chaplin = require 'chaplin'

Handlebars.registerHelper 'url', (routeName, params..., options) ->
  Chaplin.helpers.reverse routeName, params


find = ( model, path, params... ) ->
  chain = path.split '/'
  for name in chain
    model = model.get name
    return null unless model?
  return model

Handlebars.registerHelper 'get', ( path, params... ) ->
  find( @, path ).toString(params...)



Handlebars.registerHelper 'toString', ( path, params... ) ->
  @.toString params...



Handlebars.registerHelper 'clist', ( path, options) ->
  fn = options.fn
  inverse = options.inverse
  ret = ""

  context = find @, path

  if (options.data)
    data = Handlebars.createFrame options.data

  l = context.models.length-1

  for i in [0..l] by 1
    if data
      data.index = i
    ret = ret + fn(context.at(i), { data: data })


  if i is 0
    ret = inverse @

  ret
