

require [
	"AnimationControl"
	"jQuery/Easing"
	"jQuery/HashChange"
	"jQuery/WaitForImages"
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
	
	initPage = ( music ) ->
		c = new AnimationControl( music )
		c.reboot()

		jQuery( window ).hashchange( ->
			hash = location.hash.substr( 1 )

			# change story/scene
			if hash is ""
				closeStory()
			else
				c.stop()
				if match = /^scn\:(.*)/.exec( hash )
					# it's a scene
					closeStory()
					c.select( match[ 1 ])
				else
					# it's a story
					openStory( hash )
		)

		# detect hash at page load
		jQuery( window ).trigger( "hashchange" )


	jQuery( document ).ready( ->
		jQuery( window ).waitForImages( ->
			# give the music a number of seconds to load
			t = 0
			int = window.setInterval( =>
				if musicIsReady? and musicIsReady or t >= 20
					jQuery( "h1#loading" ).fadeOut( 250 )
					initPage( t < 20 )
					window.clearInterval( int )
				# increment timeout
				t++
			, 500 )
		)
	)
