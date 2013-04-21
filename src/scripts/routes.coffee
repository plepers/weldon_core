'use strict'

module.exports = (match) ->
  # match ':section', 		'mainlayout#show'
  # match ':section', 		'header#show'
  # match ':section', 		'footer#show'


###
  match 'vehicles/:range', 						'mainlayout#show'
  match 'vehicles/crossover/:model/:section', 	'pes#show'
  match 'vehicles/crossover/juke/specs/*', 		'priceandspecs#show'
###