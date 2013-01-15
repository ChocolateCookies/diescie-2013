# Array related functions as extension methods on
# the javascript native Array prototype
define [], ->
	{
		# Shuffle array using Fisher-Yates
		#
		# @param l {Array} list to shuffle
		shuffle	: ( l ) ->
			clone = l.slice(0)
			r = []

			while clone.length > 1
				#pop one element for swap
				#and get random index
				e = clone.pop()
				i = Math.floor( Math.random()*clone.length )

				#swap elements
				r.push( clone[i] )
				clone[i] = e

			#add last element from clone
			r.push( clone[0] )

			return r

		# check if a list contains an item
		#
		# @param l {Array} array to check
		# @param needle {Any} item to search for
		# @return {Boolean} true if the needle was found in l
		contains : (l, needle) ->
			return Arrays.indexOf(l, needle) isnt -1

		# get the index of an item in an array
		#
		# @param l {Array} array to check
		# @param needle {Any} item to search for
		# @return {Number} index of the needle in l, or -1 if not found
		indexOf : ( l, needle ) ->
			for i in [ l.length-1 .. 0 ]
				if l[i] is needle
					return i

			return -1

		# execute f for each element in a, passing the index and the element
		# to f on every itteration
		#
		# @param a {Array} array to loop over
		# @param f {Function} function( index, element ) {}
		each : ( a, f ) ->
			# call f vor every element in a
			for i in [ l.length-1 .. 0 ]
				f.call( a[i], i, a[i] )

			return

		# Map a to another list using f
		#
		# @param a {Array} array to loop over
		# @param f {Function} function( index, element ) {}
		map : ( a, f ) ->
			# call f vor every element in a
			for i in [ l.length-1 .. 0 ]
				f.call( a[i], i, a[i] )

		# Filter a using f
		#
		# @param a {Array} array to filter
		# @param f {Function} function( index, element ) {} returning a boolean
		filter : ( a, f ) ->
			result = []

			# check f vor every element in a
			for i in [ l.length-1 .. 0 ]
				if f.call( a[i], i, a[i] )
					result.push( a[i] )

			return result
	}
