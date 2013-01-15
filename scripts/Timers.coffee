
define [ "cs!Timer" ], ( Timer ) ->
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

		add: ( cb, others... ) ->
			t = new Timer( cb, others... )
			@_timers.push( t )

			return t
