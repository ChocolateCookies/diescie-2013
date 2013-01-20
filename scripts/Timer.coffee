
define ->
	###
		Basic Timer class, alternative for window.setTimeout and window.setInterval

		NOT PROPERLY TESTED!!! Do not use unless strictly necessary.
	###
	class Timer
		###
			@param callback	function called when time's up
			@param delay	duration for the Timer in ms
			@param repeat	Timer becomes interval if true
		###
		constructor: ( @_callback, delay, @_repeat = false ) ->
			@_start = 0
			@_id = null
			@_remaining = delay

			@resume()

		pause: ->
			if @_id?
				if @_repeat
					window.clearInterval( @_id )
				else
					window.clearTimeout( @_id )
				@_remaining -= new Date() - @_start

		resume: ->
			@_start = new Date()
			if @_repeat
				@_id = window.setInterval( @_callback, @_remaining )
			else
				@_id = window.setTimeout( @_callback, @_remaining )

		stop: ->
			@pause()
