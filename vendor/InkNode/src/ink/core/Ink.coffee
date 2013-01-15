define [ 'jquery' ], () ->

	# jQuery regex for detecting html strings
	html_rex = /^(?:[^#<]*(<[\w\W]+>)[^>]*$|#([\w\-]*)$)/

	# Ink Class > jQuery
	#
	# Inherits all jQuery power
	class Ink extends jQuery
		
		constructor: ( selector, context ) ->
			# use the contstructor as jQuery( document ).find
			if typeof selector == 'string' and not selector.match( html_rex )
				obj = jQuery.fn.init( selector, context, jQuery( document ))

				for own key, val of obj
					@[ key ] = val

			# typecasting jQuery instance to Ink
			else if selector instanceof jQuery
				self = this
				obj = selector

				for own key, val of obj
					self[ key ] = val

			# html strings
			else
				jQuery.fn.init.call( this, selector, context )

			# jQuery uses this.constructor() internally
			# and things will break if we don't keep things
			# as they are there
			@constructor = jQuery

		# Creates a timeout that calls callback after
		# ms milliseconds have passed
		#
		# @param {ms} defaults to 400 milliseconds
		# @param {callback} is called in context of this object.
		_timer = null
		timeout: ( callback, ms ) ->
			self = this

			# apply defaults
			ms ?= 400

			# call callback after ms passed in context of this object
			_timer = window.setTimeout (() -> callback.call( self )), ms

			# chainable
			this

		clear_timeout: -> 
			window.clearTimeout( _timer )

			# chainable
			this

		# Creates an interval that calls callback every time
		# ms milliseconds have passed
		#
		# @param {ms} defaults to 400 milliseconds
		# @param {callback} 
		# 	is called in context of this object.
		#	The interval object is passed to callback as the first argument.
		interval: ( callback, ms ) ->
			self = this

			# apply defaults
			ms ?= 400
		
			# set the interval
			i = window.setInterval (() -> callback.call(self, i)), ms
	
			# chainable
			this
