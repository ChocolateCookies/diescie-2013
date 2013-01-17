
define [
	"cs!Timer"
	"cs!Timers"
	"jQuery/jQuery"
	"jQuery/ScrollPath"
	"jQuery/Easing"
	"jQuery/Pause"
], ( Timer, Timers ) ->
	
	BG_SEL = "div#background"
	FG_SEL = "svg#foreground"
	BLACK_SEL = "div#black"

	FADEOUT_DUR = 500
	FADEIN_DUR = 550
	BLACK_DUR = 300
	FADE_DUR = FADEOUT_DUR + BLACK_DUR + FADEIN_DUR

	SPEED = 1

	START_1 = 4500

	LEO_1 = 5000
	LEO_2 = 8000
	LEO_3 = 2000
	LEO_TEXT = 7000

	RECEPTIE_1 = 2000
	RECEPTIE_2 = 7000
	RECEPTIE_3 = 4000
	RECEPTIE_TEXT = 2800

	LEZING_1 = 9000
	LEZING_2 = 5000
	LEZING_3 = 500
	LEZING_TEXT = 2000

	TSARWARS_1 = 8000
	TSARWARS_2 = 4000
	TSARWARS_3 = 7000
	TSARWARS_TEXT = 1500

	EXCURSIE_1 = 5000 # wait
	EXCURSIE_2 = 4000
	EXCURSIE_TEXT = 500

	BRUSJES_1 = 7000
	BRUSJES_2 = 5000
	BRUSJES_TEXT = 1500

	SPELLEN_1 = 5000
	SPELLEN_2 = 800
	SPELLEN_TEXT = 300

	HV_1 = 10000
	HV_2 = 5000
	HV_TEXT = 4000

	CABARET_1 = 14000
	CABARET_2 = 9000
	CABARET_TEXT = 3000

	TURBO_1 = 10000
	TURBO_2 = 1500 # pause
	TURBO_3 = 900 # jump on pole
	TURBO_4 = 800 # balance
	TURBO_5 = 1000 # leap
	TURBO_TEXT = 3000

	STRIJD_1 = 250 # recoil
	STRIJD_2 = 300 # recoil
	STRIJD_3 = 6000
	STRIJD_4 = 1200
	STRIJD_5 = 2000
	STRIJD_TEXT = 2000

	GALA_1 = 6000
	GALA_2 = 6000
	GALA_3 = 1500 # fade out duration
	GALA_TEXT = 3500

	BRUNCH_1 = 8000
	BRUNCH_TEXT = 4000
	
	class AnimationControl
		constructor: ->
			@_fade_timer = null
			@_timers = new Timers()
			@_current_scene = null;

			@_init_scrollpath()

			jQuery( "button#play" ).on "click", =>
				@continue()

			jQuery( "button#pause" ).on "click", =>
				@stop()

			jQuery( "button#replay" ).on "click", =>
				@reboot()
			
		select: ( scene ) ->
			if typeof @[ "_#{scene}" ] is "function"
				@_current_scene = scene
				@_fadeout_in( BLACK_DUR, => 
					@_reset_text()
					@[ "_#{scene}" ]() 
				)
				@_ctrl_pause()
			else
				jQuery.error( "#{scene} is not a valid scene" )

		reboot: ->
			@select( "start" )

		continue: ->
			@select( @_current_scene )

		current_scene: ->
			return @_current_scene

		stop: ->
			if @_timers? then @_timers.stop()
			jQuery( "div.slide-title > *" ).stop()
			if @_fade_timer? then @_fade_timer.stop()
			jQuery( "div#black" ).stop()
			jQuery.fn.scrollPath( "stop" )
			@_ctrl_play()

		pause: ->
			@_timers.pause()
			jQuery( "div.slide-title > *" ).pause()
			jQuery.fn.scrollPath( "pause" )

		resume: ->
			@_timers.resume()
			jQuery( "div.slide-title > *" ).resume()
			jQuery.fn.scrollPath( "resume" )

		_ctrl_play: ->
			jQuery( "div#controls button" ).hide()
			jQuery( "button#play" ).show()
		
		_ctrl_pause: ->
			jQuery( "div#controls button" ).hide()
			jQuery( "button#pause" ).show()
			jQuery( "button#play span" ).hide()

		_ctrl_replay: ->
			jQuery( "div#controls button" ).hide()
			jQuery( "button#replay" ).show()

		_reset_text: ->
			jQuery( "div.slide-title" ).fadeTo( 0, 0 )
				.children().removeAttr( "style" )

		_start: ->
			@_current_scene = "start"

			now = 0
			@_scrollto( "start" )

			# pan over Dies Agenda
			@_scrollto( "start_1", START_1, "linear" )
			now+=START_1

			@_timeout( =>
				@_fadeout_in( BLACK_DUR, => @_leo() )
			, now-FADEIN_DUR )

		_leo: ->
			@_current_scene = "leo";

			now = 0
			@_scrollto( "leo" )

			# go inside
			@_timeout( =>
				@_scrollto( "leo_1", LEO_1, "easeInSine" )
			, now+FADEIN_DUR )
			now+=FADEIN_DUR + LEO_1

			# pan through leo
			@_timeout( =>
				@_scrollto( "leo_2", LEO_2, "linear" )
			, now )
			now+=LEO_2

			# show text
			@_timeout( =>
				@_showtext( "leo" )
			, LEO_TEXT )

			# go upstairs
			@_timeout( =>
				@_scrollto( "receptie", LEO_3, "linear" )
			, now )
			now+=LEO_3

			@_timeout( =>
				@_receptie()
			, now )

		_receptie: ->
			@_current_scene = "receptie";

			now = 0
			@_scrollto( "receptie" )
			
			# continue upstairs
			@_scrollto( "receptie_1", RECEPTIE_1, "linear" )
			now+=RECEPTIE_1

			# pan through lezing
			@_timeout( =>
				@_scrollto( "receptie_2", RECEPTIE_2, "linear" )
			, now )
			now+=RECEPTIE_2

			# show text
			@_timeout( =>
				@_showtext( "receptie" )
			, RECEPTIE_TEXT )

			# continue to lezing
			@_timeout( =>
				@_scrollto( "lezing", RECEPTIE_3, "linear" )
			, now )
			now+=RECEPTIE_3

			@_timeout( =>
				@_lezing()
			, now )

		_lezing: ->
			@_current_scene = "lezing";

			now = 0
			@_scrollto( "lezing" )

			# pan through lezing and go outside
			@_scrollto( "courtyard", LEZING_1, "linear" )
			now+=LEZING_1

			# show text
			@_timeout( =>
				@_showtext( "lezing" )
			, LEZING_TEXT )

			# go downstairs to the courtyard
			@_timeout( =>
				@_scrollto( "courtyard_1", LEZING_2, "linear" )
			, now )
			now+=LEZING_2

			# proceed to tsarwars
			@_timeout( =>
				@_scrollto( "tsarwars", LEZING_3, "linear" )
			, now )
			now+=LEZING_3

			@_timeout( =>
				@_tsarwars()
			, now )

		_tsarwars: ->
			@_current_scene = "tsarwars";

			now = 0
			@_scrollto( "tsarwars" )

			# pan through tsarwars
			@_scrollto( "tsarwars_1", TSARWARS_1, "linear" )
			now+=TSARWARS_1

			# show text
			@_timeout( =>
				@_showtext( "tsarwars" )
			, TSARWARS_TEXT )

			# walk to the ladder
			@_timeout( =>
				@_scrollto( "tsarwars_2", TSARWARS_2, "easeOutSine" )
			, now )
			now+=TSARWARS_2

			# go up the ladder to excursie
			@_timeout( =>
				@_scrollto( "excursie", TSARWARS_3, "easeInOutSine" )
			, now )
			now+=TSARWARS_3

			@_timeout( =>
				@_excursie()
			, now )

		_excursie: ->
			@_current_scene = "excursie";

			now = 0
			@_scrollto( "excursie" )

			# wait a moment on the balcony
			@_timeout( =>
				# continue to brusjesdag
				@_scrollto( "brusjesdag", EXCURSIE_2, "easeInSine" )
			, EXCURSIE_1 )
			now+=EXCURSIE_1+EXCURSIE_2

			# show text
			@_timeout( =>
				@_showtext( "excursie" )
			, EXCURSIE_TEXT )

			@_timeout( =>
				@_brusjesdag()
			, now )

		_brusjesdag: ->
			@_current_scene = "brusjesdag";

			now = 0
			@_scrollto( "brusjesdag" )

			# pan through brusjesdag and go to spellen
			@_scrollto( "spellen", BRUSJES_1, "linear" )
			now+=BRUSJES_1

			# show text
			@_timeout( =>
				@_showtext( "brusjesdag" 
					duration: 3000
					reverse: true
				)
			, BRUSJES_TEXT )

			@_timeout( =>
				@_spellen()
			, now )

		_spellen: ->
			@_current_scene = "spellen";

			now = 0
			@_scrollto( "spellen" )

			# pan through spellen
			@_scrollto( "spellen_1", SPELLEN_1, "linear" )
			now+=SPELLEN_1

			# show text
			@_timeout( =>
				@_showtext( "spellen" 
					duration: 4000
				)
			, SPELLEN_TEXT )

			# jump down the trap to hv
			@_timeout( =>
				@_scrollto( "hv", SPELLEN_2, "easeInQuad" )
			, now )
			now+=SPELLEN_2

			@_timeout( =>
				@_hv()
			, now )

		_hv: ->
			@_current_scene = "hv";

			now = 0
			@_scrollto( "hv" )

			# pan through hv
			@_scrollto( "hv_1", HV_1, "easeInSine" )
			now+=HV_1

			# show text
			@_timeout( =>
				@_showtext( "hv" )
			, HV_TEXT )

			# go down the stairs to cabaret
			@_timeout( =>
				@_scrollto( "cabaret", HV_2, "linear" )
			, now )
			now+=HV_2

			@_timeout( =>
				@_cabaret()
			, now )

		_cabaret: ->
			@_current_scene = "cabaret";

			now = 0
			@_scrollto( "cabaret" )

			# pan through cabaret
			@_scrollto( "cabaret_1", CABARET_1, "linear" )
			now+=CABARET_1

			# show text
			@_timeout( =>
				@_showtext( "cabaret" )
			, CABARET_TEXT )

			# continue up the big stairs
			@_timeout( =>
				@_scrollto( "turbokring", CABARET_2, "easeInOutSine" )
			, now )
			now+=CABARET_2

			@_timeout( =>
				@_turbokring()
			, now )

		_turbokring: ->
			@_current_scene = "turbokring";

			now = 0
			@_scrollto( "turbokring" )

			# pan through turbokring
			@_scrollto( "turbo_1", TURBO_1, "linear" )
			now+=TURBO_1

			# show text
			@_timeout( =>
				@_showtext( "turbokring" )
			, TURBO_TEXT )

			# pause for effect
			# jump out the window, on the flagpole
			@_timeout( =>
				@_scrollto( "turbo_2", TURBO_3, "easeInSine" )
			, now+TURBO_2 )
			now+=TURBO_2+TURBO_3

			# balance on the pole
			@_timeout( =>
				@_scrollto( "turbo_3", TURBO_4, "linear" )
			, now )
			now+=TURBO_4
			@_timeout( =>
				@_scrollto( "turbo_4", TURBO_4, "linear" )
			, now )
			now+=TURBO_4
			@_timeout( =>
				@_scrollto( "turbo_5", TURBO_4, "linear" )
			, now )
			now+=TURBO_4
			@_timeout( =>
				@_scrollto( "turbo_6", TURBO_4, "linear" )
			, now )
			now+=TURBO_4

			# take the huge leap onto the roof to verticalenstrijd
			@_timeout( =>
				@_scrollto( "verticalenstrijd", TURBO_5, "easeInSine" )
			, now )
			now+=TURBO_5

			@_timeout( =>
				@_verticalenstrijd()
			, now )

		_verticalenstrijd: ->
			@_current_scene = "verticalenstrijd";

			now = 0
			@_scrollto( "verticalenstrijd" )

			# recoil from the jump
			@_scrollto( "strijd_1", STRIJD_1, "linear" )
			now+=STRIJD_1
			@_timeout( =>
				@_scrollto( "strijd_2", STRIJD_2, "linear" )
			, now )
			now+=STRIJD_2

			# pan through verticalenstrijd
			@_timeout( =>
				@_scrollto( "strijd_3", STRIJD_3, "easeInSine" )
			, now )
			now+=STRIJD_3

			# climb through the window
			@_timeout( =>
				@_scrollto( "strijd_4", STRIJD_4, "easeInSine" )
			, now )
			now+=STRIJD_4

			# jump down unto the dancefloor after a short break
			@_timeout( =>
				@_scrollto( "gala", STRIJD_5, "easeOutSine" )
			, now )
			now+=STRIJD_5

			# show text
			@_timeout( =>
				@_showtext( "verticalenstrijd" )
			, STRIJD_TEXT )

			@_timeout( =>
				@_gala()
			, now )

		_gala: ->
			@_current_scene = "gala";

			now = 0
			@_scrollto( "gala" )

			# pan through gala
			@_scrollto( "gala_1", GALA_1, "linear" )
			now+=GALA_1

			# pan up
			@_timeout( =>
				@_scrollto( "gala_2", GALA_2, "linear" )
			, now )
			now+=GALA_2

			# fade out
			@_timeout( =>
				@_fadeout_in( GALA_3 )
			, now-FADEOUT_DUR )
			now+=GALA_3

			# show text
			@_timeout( =>
				@_showtext( "gala"
					reverse: true
				)
			, GALA_TEXT )

			@_timeout( =>
				@_dedebrunch()
			, now )

		_dedebrunch: ->
			@_current_scene = "dedebrunch";

			now = 0
			@_scrollto( "dedebrunch" )

			# pan down brunch
			@_scrollto( "brunch_1", BRUNCH_1, "easeInOutSine" )
			now+=BRUNCH_1

			# show text
			@_timeout( =>
				@_showtext( "dedebrunch" 
					duration: 6000
					reverse: true
				)
			, BRUNCH_TEXT )
			now+=BRUNCH_TEXT

			@_timeout( =>
				@_ctrl_replay()
			, now )

		_showtext: ( target, options = {} ) ->
			# define default options
			defaults =
				duration: 5000
				reverse: false
			options = jQuery.extend( defaults, options )

			# direction of animated text
			h1Left = if options.reverse then "-=150" else "+=150"
			h2Left = if options.reverse then "+=150" else "-=150"

			el = jQuery( "div##{target}" )
			el.fadeTo( 400, 1 )
				.find( "h1" ).animate(
					left: h1Left
				,
					easing: "linear"
					duration: 10000
				).siblings( "h2" ).animate(
					left: h2Left
				,
					easing: "linear"
					duration: 10000
				)

			@_timeout( =>
				el.fadeTo( 400, 0 )
			, options.duration )

		_scrollto: ( target, duration, callback ) ->
			jQuery.fn.scrollPath( "scrollTo", target, duration/SPEED, callback )

		_timeout: ( cb, delay ) ->
			@_timers.add( cb, delay )

		_fadeout: ( cb = -> ) ->
			jQuery( BLACK_SEL ).stop().fadeIn( 500, cb )
		
		_fadein: ( cb = -> ) ->
			jQuery( BLACK_SEL ).stop().fadeOut( 550, cb )

		_fadeout_in: ( delay = 250, cb1, cb2 ) ->
			if @_fade_timer?
				@_fade_timer.stop()

			@_fadeout( =>
				@_fade_timer = new Timer( =>
					if cb1? then cb1()
					@_fadein( cb2 )
				, delay )
			)

		_init_scrollpath: ->
			PI = Math.PI

			# Intro
			P0 = { x:480, y:3250 }
			P01 = { x:900, y:P0.y }

			# LeO
			P1 = { x:500, y:2650 }
			C1 = { rad:50, x:P1.x+500-50, y:P1.y-50 }
			C2 = { rad:350, x:C1.x-350+C1.rad, y:C1.y-100 }
			C3 = { rad:300, x:C2.x+(300+C2.rad)*Math.cos(PI/4), y:C2.y-(300+C2.rad)*Math.sin(PI/4) }

			# Receptie
			C4 = { rad:100, x:C3.x-(C3.rad-100), y:C3.y }

			# Lezing
			C5 = { rad:90, x:C4.x+100, y:C4.y-(C4.rad+90) }
			C6 = { rad:150, x:C5.x, y:C5.y-(C5.rad+150) }

			# Binnenplaats trap
			C7 = { rad:20, x:1710, y:C6.y-150+20 } 
			C8 = { rad:100, x:C7.x+C7.rad+100, y:C7.y+750 }

			# Tsar Wars
			C9 = { rad:100, x:C8.x, y:C8.y+100+C8.rad }
			C10 = { rad:100, x:C9.x+700, y:C9.y+140 }
			P2 = { x:2810, y:Math.round(C10.y+C10.rad) }

			# Excursie
			P3 = { x:P2.x, y:1800 }

			# Brusjesdag
			P4 = { x:3270, y:P3.y }

			# Spellen
			P5 = { x:3850, y:P3.y }
			C11 = { rad:150, x:P5.x, y:P5.y+150 }

			# Installatie H.V.
			P6 = { x:C11.x+C11.rad, y:2300 }
			C12 = { rad:150, x:3300, y:P6.y+150 }

			# Op de planken
			C13 = { rad:50, x:C12.x-C12.rad+50, y:2775 }
			C14 = { rad:50, x:4180, y:C13.y }

			# Turbokring
			C15 = { rad:50, x:C14.x, y:1400 }
			P7 = { x:3250, y:C15.y-C15.rad }
			C16 = { rad:250, x:P7.x-Math.cos(PI/8)*250, y:C15.y-C15.rad+Math.sin(PI/8)*250 }
			P8 = { x:2879, y:1281 }
			P9 = { x:2833, y:1285 }
			P10 = { x:2825, y:1252 }
			P11 = { x:2850, y:1252 }

			# Verticalenstrijd
			C17 = { rad:700, x:2205, y:1520 }
			C17_INTX = C17.x-Math.cos(PI*3/8)*C17.rad
			C17_INTY = C17.y-Math.sin(PI*3/8)*C17.rad
			P12 = { x:C17_INTX-20, y:C17_INTY+20 } # recoil 1
			P13 = { x:C17_INTX, y:C17_INTY } # recoil 2
			P14 = { x:C17_INTX+940, y:C17_INTY } # to the window
			C18 = { rad:170, x:2880+Math.cos(PI/8)*170, y:C17_INTY+Math.sin(PI/8)*170 }

			# Gala
			C19 = { rad:100, x:3080, y:860 }
			C20 = { rad:50, x:3620, y:C19.y-Math.sin(PI/8)*C19.rad-50 }
			P15 = { x:C20.x+C20.rad, y:270 }

			# DeDe brunch
			P16 = { x:4480, y:270 }
			P17 = { x:P16.x, y:950 }

			jQuery.fn.scrollPath("getPath", 
				scrollSpeed: 40
			)
				# intro
				.moveTo( P0.x, P0.y, { name: "start" })
				.lineTo( P01.x, P01.y, { name: "start_1" })

				# arrive with horse and carriage, go inside, to Tuesday: "LeO"
				.moveTo( P1.x, P1.y, { name: "leo" })
				.arc( C1.x, C1.y, C1.rad, PI/2, 0, true, { name: "leo_1" })
				.arc( C2.x, C2.y, C2.rad, 0, -PI/4, true, { name: "leo_2" } )

				# walk up the stairs, to Wednesday: "Recepski"
				.arc( C3.x, C3.y, C3.rad, 3/4*PI, PI, false, { name: "receptie" } )
				.arc( C4.x, C4.y, C4.rad, PI, -PI/2, false, { name: "receptie_1" })
				.arc( C5.x, C5.y, C5.rad, PI/2, -PI/2, true, { name: "receptie_2" })

				# continue up the stairs, to Thursday: "Letzing"
				.arc( C6.x, C6.y, C6.rad, PI/2, -PI/2, false, { name: "lezing" })

				# go outside, to the courtyard, down the stairs
				.arc( C7.x, C7.y, C7.rad, -PI/2, 0, false, { name: "courtyard" })
				.arc( C8.x, C8.y, C8.rad, PI, PI/2, true, { name: "courtyard_1" })

				# proceed to the courtyard, to Friday: "Tsar Wars"
				.arc( C9.x, C9.y, C9.rad, -PI/2, -PI/3, false, { name: "tsarwars" })
				.arc( C10.x, C10.y, C10.rad, PI/12*7, PI/2, true, { name: "tsarwars_1" })
				.lineTo( P2.x, P2.y, { name: "tsarwars_2" })

				# climb up the ladder, still Friday, but "Ekskursyi"
				.lineTo( P3.x, P3.y, { name: "excursie" })

				# enter the west wing, to Saturday: "Bruzjesdag"
				.lineTo( P4.x, P4.y, { name: "brusjesdag" })

				# continue to the next room for Sunday: "Geszelschap Speylen Geszelschap"
				.lineTo( P5.x, P5.y, { name: "spellen" })
				.arc( C11.x, C11.y, C11.rad, -PI/2, 0, false, { name: "spellen_1" })

				# jump down the trapdoor, attending "Huishoudlijk Vergadring" on Monday
				.lineTo( P6.x, P6.y, { name: "hv" })
				.arc( C12.x, C12.y, C12.rad, -PI/2, -PI, true, { name: "hv_1" })

				# go down the stairs, to Tuesday: "Kabarat"
				.arc( C13.x, C13.y, C13.rad, PI, PI/2, true, { name: "cabaret" })
				.arc( C14.x, C14.y, C14.rad, PI/2, 0, true, { name: "cabaret_1" })

				# up the stairs again, to Wednesday: "Turbokring"
				.arc( C15.x, C15.y, C15.rad, 0, -PI/2, true, { name: "turbokring" })
				.lineTo( P7.x, P7.y, { name: "turbo_1" })
				# hop out the window, on the flagpole, balance a little
				.arc( C16.x, C16.y, C16.rad, -PI/8, -PI*3/4, true, { name: "turbo_2" })
				.lineTo( P8.x, P8.y, { name: "turbo_3" })
				.lineTo( P9.x, P9.y, { name: "turbo_4" })
				.lineTo( P10.x, P10.y, { name: "turbo_5" })
				.lineTo( P11.x, P11.y, { name: "turbo_6" })

				# take a huge leap and jump on the roof, to Thursday: "Stryd y Vertikalny"
				.arc( C17.x, C17.y, C17.rad, -PI/8, -PI*5/8, true, { name: "verticalenstrijd" })
				.lineTo( P12.x, P12.y, { name: "strijd_1" })
				.lineTo( P13.x, P13.y, { name: "strijd_2" })
				.lineTo( P14.x, P14.y, { name: "strijd_3" })
				.arc( C18.x, C18.y, C18.rad, -PI*7/8, -PI/2, false, { name: "strijd_4" })

				# climb inside to the gala on Friday
				.arc( C19.x, C19.y, C19.rad, -PI*5/8, -PI/8, false, { name: "gala" })
				.arc( C20.x, C20.y, C20.rad, PI/2, 0, true, { name: "gala_1" })
				.lineTo( P15.x, P15.y, { name: "gala_2" })

				# transition to Saturday: "DeDe Bryunsz"
				.moveTo( P16.x, P16.y, { name: "dedebrunch" })
				.lineTo( P17.x, P17.y, { name: "brunch_1" })
				
			jQuery( "div#background" ).scrollPath(
				scroll: false
			)
