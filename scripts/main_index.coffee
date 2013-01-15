
define [
	"cs!AnimationControl"
	"jQuery/Easing"
], ( AnimationControl ) ->
	jQuery( document ).ready ->
		c = new AnimationControl()

		c.select( "dedebrunch" )
