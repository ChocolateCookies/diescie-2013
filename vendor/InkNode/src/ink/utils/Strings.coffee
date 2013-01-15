# String related functions as extension methods on
# the javascript native String prototype
define [], ->
	{
		nl2br: ( string ) -> string.replace( /[\n\r(\n\r)(\r\n)]/g, '<br />' )

		br2nl: (string) -> string.replace( /<br\s*\/?>/mg, "\n" )

		repeat: ( str, n ) ->
			result = ""
			for i in [ 1..n ]
				result = result + str 
			
			return result

		rpad: ( str, l, c ) ->
			c = c or " "

			for i in [ ( l - str.length ) .. 1 ]
				str += c

			return str
		
		lpad: ( str, l, c ) ->
			c = c or " "

			for i in [ ( l - str.length ) .. 1 ]
				str = c + str

			return str

		# mimics python string interpolation
		#
		# @param str {String} string to interpolate with needles
		# @param needles {Array<String, Number>} items to place into str
		sprintf: ( str, needles... ) ->
			# replace the matches
			for needle in needles
				# nice regex for finding replace values
				# we end up with three groups: pre, replace and post string
				rex = /(.*?)%(s|d\d+)(.*)$/g
				
				# find all replace values
				matches = rex.exec( str )
				
				# check what we need to place
				# skip the first match, because we're only interested
				# in groups
				if matches.length is 4 
					# start with the pre replacement string
					res = matches[1]

					# execute the replacement
					if matches[2] is "s" 
						# replace the string
						res = res + needle
					else if matches[2][0] is "d"
						# round to the right length
						# and replace the string
						length = parseInt( Array.prototype.splice.call( matches[2],  1 ))
						mult =  Math.pow( 10, length )
						res = res + ( Math.round( needle * mult ) / mult )
					
					# end with the post replacement string
					res = res + matches[3]
					str = res
				else
					# we couldn't find anything to replace
					return str

			return str
	}
