
define [ "Timer" ], ( Timer ) ->
	###
		Class for managing multiple Timer instances.

		NOT PROPERLY TESTED!!! Do not use unless strictly necessary.
	###
	class Timers
		constructor: ->
			@_timers = []

		pause: ->
			t.pause() for t in @_timers

		resume: ->
			t.resume() for t in @_timers

		stop: ->
			t.stop() for t in @_timers
			@_timers = []

		###
			Adds a Timer instance to the array.
			For param definitions, see Timer constructor
		###
		add: ( cb, others... ) ->
			t = new Timer( cb, others... )
			@_timers.push( t )

			return t
