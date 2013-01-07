
define [
	"cs!AnimationControl"
], ( AnimationControl ) ->
	jQuery( document ).ready ->
		jQuery( "div#window" ).on( "scroll", ( e ) ->
			jQuery( "p#debug" ).text(
				"#{jQuery( @ ).scrollTop()}, #{jQuery( @ ).scrollLeft()}"
			)
		)
		
		c = new AnimationControl()

		#c._scrollto( "dedebrunch" )
		c.reboot()
