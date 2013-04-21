'use strict'

Chaplin = require 'chaplin'
routes = require './routes'
config = require 'core_config'

# init handlebars helpers
require './view-helper'

class Application extends Chaplin.Application

  initialize: ->
    # Initialize chaplin core
    @initDispatcher config
    @initRouter routes
    @initComposer()
    @initLayout()
    @initMediator()

    # Start routing.
    @startRouting()

    # console.log "will testDomMdlLoading now "

    # @dispatcher.testDomMdlLoading()
    # Freeze the object instance; prevent further changes
    Object.freeze? @


  initMediator: ->
    # Attach with semi-globals here.
    Chaplin.mediator.seal()


app = new Application()
app.initialize()

module.exports =
  app : app,
  config : config



