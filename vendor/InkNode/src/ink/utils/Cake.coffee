# Cake class
#
# Contains class methods for gettings/settings cookies
# in an intuitive way
#
# @author A.J. Rouvoet
define [], ->

	class Cake
		# Get a previously defined cookie. 
		# Or return null if a cookie with name was not found.
		#
		# @param name {String} Name of the cookie to get
		@get: ( name ) ->
			if document.cookie
				cookies = document.cookie.split( '; ' )
				
				if ( cookies )
					# look for the right cookie
					for cookie in cookies[0..]
						parts = cookie.split( '=' )
						if parts[0] is escape( name )

							# if we found the right cookie by name
							# return it's contents
							return unescape( parts[1] )

			# return null if the search resulted in nothing
			return null

		# Adds a cookie for the root
		#
		# Both the name and value arguments should be strings.
		# Days is an optional argument - defaults to 0 - to set
		# the expiration offset in days from now.
		#	
		# Cake will handle escaping the values
		#
		# @param name {String} name of the new cookie
		# @param value {String} value of the new cookie
		# @param days {Number} number of days the cookies needs to be valid
		@set: ( name, value, days ) ->
			date = null
			expiration = ""

			# validate name/value
			if not name? or name.search( /;/ ) isnt -1
				throw 'name argument should be a string of length > 0'

			# get the proper date expires date format
			if days
				date = new Date()
				date.setTime( date.getTime() + ( days*24*60*60*1000 ))
				expiration = " expires=" + date.toUTCString()

			document.cookie = "#{ escape( name ) }= #{ escape( value ) }; #{ expiration }; path=/"

		# Remove a previously added cookie.
		#
		# @note equivalent to Cake.set(name, "", -1)
		# @param name {String} Name of the cookie to remove
		@purge: ( name ) -> Cake.set( name, "", -1 )
