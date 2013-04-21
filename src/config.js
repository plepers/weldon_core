'use strict';

require.config({
  paths: {
    underscore:     '../libs/scripts/underscore/underscore',
    jquery:         '../libs/scripts/jquery/jquery',
    json2:          '../libs/scripts/json3/json3',
    backbone:       '../libs/scripts/backbone/backbone',
    handlebars:     '../libs/scripts/handlebars/handlebars.runtime',
    chaplin:        '../libs/scripts/chaplin/chaplin',
    core_config:    'empty:'
  },
  shim: {
    handlebars: {
      exports: 'Handlebars'
    }
  }
});