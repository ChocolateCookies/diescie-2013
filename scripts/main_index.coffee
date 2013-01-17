
require [
	"cs!AnimationControl"
	"jQuery/Easing"
	"jQuery/HashChange"
], ( AnimationControl ) ->

	closeStory = ->
		jQuery( "div.story" ).stop().fadeOut( 200 )
		jQuery( "button#close-story" ).stop().fadeOut( 200 )

	openStory = ( name ) ->
		closeStory()

		jQuery( "div##{ name }" ).stop().fadeIn( 200, ->
			jQuery( "div#black" ).show()
			jQuery( "button#play span" ).show()
		)
		jQuery( "button#close-story" ).stop().fadeIn( 200 )

	jQuery( document ).ready ->
		c = new AnimationControl()
		c.select( "start" )

		jQuery( window ).hashchange( ->
			hash = location.hash.substr( 1 )

			if hash is ""
				closeStory()
			else
				c.stop()
				openStory( hash )
		)

		# detect hash at page load
		jQuery( window ).trigger( "hashchange" )
			
