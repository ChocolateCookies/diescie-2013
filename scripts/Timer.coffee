
define ->
	class Timer
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
			delete @
