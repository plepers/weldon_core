'use strict'

Chaplin = require 'chaplin'
routes = require './routes'



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


app = null

config =
  controllerSuffix: '/controller',
  controllerPath: ''
  domModelContainer : document.getElementById '_skeleton'

running = false

_run = ( cfg )->

  return if running
  config = cfg
  app = new Application()
  app.initialize()

module.exports =
  run : _run



