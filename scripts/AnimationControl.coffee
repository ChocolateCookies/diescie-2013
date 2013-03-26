
define [
	"Timer"
	"Timers"
	"jQuery/jQuery"
	"jQuery/ScrollPath"
	"jQuery/Easing"
], ( Timer, Timers ) ->
	
	###
		Class for managing the animation for the background image.
		Also manages audio (if enabled).
	###
	BG_SEL = "div#background"
	FG_SEL = "svg#foreground"
	BLACK_SEL = "div#black"
	MUSIC_SEL = "#music"

	FADEOUT_DUR = 500
	FADEIN_DUR = 550
	BLACK_DUR = 300
	FADE_DUR = FADEOUT_DUR + BLACK_DUR + FADEIN_DUR

	# Durations for ScrollPath animation
	INTRO = [
		9000
	]

	LEO = [
		10000
		8000
		4000
	]
	LEO_TEXT = 11000

	RECEPTIE = [
		3000
		9000
		3000
	]
	RECEPTIE_TEXT = 5000

	LEZING = [
		11000 # pan
		8000 # stairs
		800
	]
	LEZING_TEXT = 800

	TSARWARS = [
		8000
		5000
		8000
	]
	TSARWARS_TEXT = 1500

	EXCURSIE = [
		4500 # wait
		8000
	]
	EXCURSIE_TEXT = 1500

	BRUSJES = [
		8000
	]
	BRUSJES_TEXT = 500

	SPELLEN = [
		6400
		1000
	]
	SPELLEN_TEXT = 0

	HV = [
		9500
		2500
	]
	HV_TEXT = 2500

	CABARET = [
		11500
		8000
	]
	CABARET_TEXT = 3000

	TURBO = [
		11000
		1000 # pause
		800 # jump on pole
		600 # balance
		600 # balance
		600 # balance
		600 # balance
		1000 # leap
	]
	TURBO_TEXT = 4500

	STRIJD = [
		250 # recoil
		300 # recoil
		11000
		1200
		2500
	]
	STRIJD_TEXT = 4000

	GALA = [
		9000
		5500
		1500 # fade out duration
	]
	GALA_TEXT = 4000

	BRUNCH = [
		9000
	]
	BRUNCH_TEXT = 5000
	
	class AnimationControl
		constructor: ( @_music_enabled = true ) ->
			@_fade_timer = null
			@_timers = new Timers()

			@_current_scene = null;

			# audio related members
			@_music = document.getElementById( "music" )
			@_current_volume = 1
			@_mute = false
			@_replaycount = 0

			# initialize the ScrollPath to animate over
			@_init_scrollpath()

			# event handlers
			jQuery( "button#play" ).on "click", =>
				@continue()

			jQuery( "button#pause" ).on "click", =>
				@stop()

			jQuery( "button#replay" ).on "click", =>
				# a litte TRO'LIN
				@_replaycount++
				if @_music_enabled and @_replaycount == 8 # b'vo
					@_music.pause()
					@_music = document.getElementById( "trolmusic" )

				@reboot()

			if @_music_enabled
				# init sound controls
				jQuery( "button#toggle-sound" ).on "click", ( e ) =>
					el = jQuery( e.target )
					if el.hasClass( "sound-off" )
						@_mute = false
						jQuery( @_music ).stop().animate(
							volume: @_current_volume
						, 300 )
					else
						@_mute = true
						@_current_volume = @_music.volume
						jQuery( @_music ).stop().animate(
							volume: 0
						, 300 )

					el.toggleClass( "sound-off" )
			else
				jQuery( "button#toggle-sound" ).addClass( "no-sound" )
			
		select: ( scene ) ->
			# check existance of scene
			if typeof @[ "_#{scene}" ] is "function"
				@stop()
				@_current_scene = scene
				@_fadeout_in( BLACK_DUR, => 
					@_reset_text()
					@[ "_#{scene}" ]() 
				)
				@_ctrl_pause()

				if @_music_enabled
					# start playing at the right time
					@_music.play()
					@_music.currentTime = Math.round( @_get_music_ms( scene ) / 1000 )

				if not @_mute
					# fade in music
					jQuery( @_music ).stop().animate(
						volume: 1
					, 300 )
			else
				jQuery.error( "#{scene} is not a valid scene" )

		reboot: ->
			@select( "intro" )

		continue: ->
			@select( @_current_scene )

		current_scene: ->
			return @_current_scene

		stop: ->
			# stop ScrollPath animation
			if @_timers? then @_timers.stop()
			jQuery( "div.slide-title > *" ).stop()
			jQuery.fn.scrollPath( "stop" )

			# stop any ongoing fades
			jQuery( "div#black" ).stop()
			if @_fade_timer? then @_fade_timer.stop()

			@_ctrl_play()

			if not @_mute
				# fade music to background volume
				jQuery( @_music ).stop().animate(
					volume: 0.5
				, 300 )

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

		###
			Scene definitions
			Used by select() to skip to scene
		###
		_intro: ->
			@_current_scene = "intro"

			now = 0
			@_scrollto( @_current_scene )

			# pan over Dies Agenda
			@_scrollto( "intro_1", INTRO[0], "linear" )
			now+=INTRO[0]

			@_timeout( =>
				@_fadeout_in( BLACK_DUR, => @_leo() )
			, now-FADEOUT_DUR)

		_leo: ->
			@_current_scene = "leo";

			now = 0
			@_scrollto( @_current_scene )

			# go inside
			@_timeout( =>
				@_scrollto( "leo_1", LEO[0], "easeInSine" )
			, now+FADEIN_DUR )
			now+=FADEIN_DUR + LEO[0]

			# pan through leo
			@_timeout( =>
				@_scrollto( "leo_2", LEO[1], "linear" )
			, now )
			now+=LEO[1]

			# show text
			@_timeout( =>
				@_showtext( "leo" )
			, LEO_TEXT )

			# go upstairs
			@_timeout( =>
				@_scrollto( "recepski", LEO[2], "linear" )
			, now )
			now+=LEO[2]

			@_timeout( =>
				@_recepski()
			, now )

		_recepski: ->
			@_current_scene = "recepski";

			now = 0
			@_scrollto( @_current_scene );
			
			# continue upstairs
			@_scrollto( "recepski_1", RECEPTIE[0], "linear" )
			now+=RECEPTIE[0]

			# pan through letszing
			@_timeout( =>
				@_scrollto( "recepski_2", RECEPTIE[1], "linear" )
			, now )
			now+=RECEPTIE[1]

			# show text
			@_timeout( =>
				@_showtext( "recepski" )
			, RECEPTIE_TEXT )

			# continue to letszing
			@_timeout( =>
				@_scrollto( "letszing", RECEPTIE[2], "linear" )
			, now )
			now+=RECEPTIE[2]

			@_timeout( =>
				@_letszing()
			, now )

		_letszing: ->
			@_current_scene = "letszing";

			now = 0
			@_scrollto( @_current_scene )

			# pan through letszing and go outside
			@_scrollto( "courtyard", LEZING[0], "linear" )
			now+=LEZING[0]

			# show text
			@_timeout( =>
				@_showtext( "letszing" )
			, LEZING_TEXT )

			# go downstairs to the courtyard
			@_timeout( =>
				@_scrollto( "courtyard_1", LEZING[1], "linear" )
			, now )
			now+=LEZING[1]

			# proceed to tsarwars
			@_timeout( =>
				@_scrollto( "tsarwars", LEZING[2], "linear" )
			, now )
			now+=LEZING[2]

			@_timeout( =>
				@_tsarwars()
			, now )

		_tsarwars: ->
			@_current_scene = "tsarwars";

			now = 0
			@_scrollto( @_current_scene )

			# pan through tsarwars
			@_scrollto( "tsarwars_1", TSARWARS[0], "linear" )
			now+=TSARWARS[0]

			# show text
			@_timeout( =>
				@_showtext( "tsarwars" )
			, TSARWARS_TEXT )

			# walk to the ladder
			@_timeout( =>
				@_scrollto( "tsarwars_2", TSARWARS[1], "easeOutSine" )
			, now )
			now+=TSARWARS[1]

			# go up the ladder to ekskurzyi
			@_timeout( =>
				@_scrollto( "ekskurzyi", TSARWARS[2], "easeInOutSine" )
			, now )
			now+=TSARWARS[2]

			@_timeout( =>
				@_ekskurzyi()
			, now )

		_ekskurzyi: ->
			@_current_scene = "ekskurzyi";

			now = 0
			@_scrollto( @_current_scene )

			# wait a moment on the balcony
			@_timeout( =>
				# continue to bruzjesdag
				@_scrollto( "bruzjesdag", EXCURSIE[1], "easeInSine" )
			, EXCURSIE[0])
			now+=EXCURSIE[0]+EXCURSIE[1]

			# show text
			@_timeout( =>
				@_showtext( "ekskurzyi" )
			, EXCURSIE_TEXT )

			@_timeout( =>
				@_bruzjesdag()
			, now )

		_bruzjesdag: ->
			@_current_scene = "bruzjesdag";

			now = 0
			@_scrollto( @_current_scene )

			# pan through bruzjesdag and go to gsg
			@_scrollto( "gsg", BRUSJES[0], "linear" )
			now+=BRUSJES[0]

			# show text
			@_timeout( =>
				@_showtext( "bruzjesdag" 
					duration: 3000
					reverse: true
				)
			, BRUSJES_TEXT )

			@_timeout( =>
				@_gsg()
			, now )

		_gsg: ->
			@_current_scene = "gsg";

			now = 0
			@_scrollto( @_current_scene )

			# pan through gsg
			@_scrollto( "gsg_1", SPELLEN[0], "linear" )
			now+=SPELLEN[0]

			# show text
			@_timeout( =>
				@_showtext( "gsg" 
					duration: 4000
				)
			, SPELLEN_TEXT )

			# jump down the trap to hv
			@_timeout( =>
				@_scrollto( "hv", SPELLEN[1], "easeInQuad" )
			, now )
			now+=SPELLEN[1]

			@_timeout( =>
				@_hv()
			, now )

		_hv: ->
			@_current_scene = "hv";

			now = 0
			@_scrollto( @_current_scene )

			# pan through hv
			@_scrollto( "hv_1", HV[0], "linear" )
			now+=HV[0]

			# show text
			@_timeout( =>
				@_showtext( "hv" )
			, HV_TEXT )

			# go down the stairs to kabarad
			@_timeout( =>
				@_scrollto( "kabarad", HV[1], "linear" )
			, now )
			now+=HV[1]

			@_timeout( =>
				@_kabarad()
			, now )

		_kabarad: ->
			@_current_scene = "kabarad";

			now = 0
			@_scrollto( @_current_scene )

			# pan through kabarad
			@_scrollto( "kabarad_1", CABARET[0], "linear" )
			now+=CABARET[0]

			# show text
			@_timeout( =>
				@_showtext( "kabarad" )
			, CABARET_TEXT )

			# continue up the big stairs
			@_timeout( =>
				@_scrollto( "tyurbokring", CABARET[1], "linear" )
			, now )
			now+=CABARET[1]

			@_timeout( =>
				@_tyurbokring()
			, now )

		_tyurbokring: ->
			@_current_scene = "tyurbokring";

			now = 0
			@_scrollto( @_current_scene )

			# pan through tyurbokring
			@_scrollto( "turbo_1", TURBO[0], "linear" )
			now+=TURBO[0]

			# show text
			@_timeout( =>
				@_showtext( "tyurbokring" )
			, TURBO_TEXT )

			# pause for effect
			# jump out the window, on the flagpole
			@_timeout( =>
				@_scrollto( "turbo_2", TURBO[2], "easeInSine" )
			, now+TURBO[1] )
			now+=TURBO[1]+TURBO[2]

			# balance on the pole
			@_timeout( =>
				@_scrollto( "turbo_3", TURBO[3], "linear" )
			, now )
			now+=TURBO[3]
			@_timeout( =>
				@_scrollto( "turbo_4", TURBO[4], "linear" )
			, now )
			now+=TURBO[4]
			@_timeout( =>
				@_scrollto( "turbo_5", TURBO[5], "linear" )
			, now )
			now+=TURBO[5]
			@_timeout( =>
				@_scrollto( "turbo_6", TURBO[6], "linear" )
			, now )
			now+=TURBO[6]

			# take the huge leap onto the roof to stryd
			@_timeout( =>
				@_scrollto( "stryd", TURBO[7], "easeInSine" )
			, now )
			now+=TURBO[7]

			@_timeout( =>
				@_stryd()
			, now )

		_stryd: ->
			@_current_scene = "stryd";

			now = 0
			@_scrollto( @_current_scene )

			# recoil from the jump
			@_scrollto( "strijd_1", STRIJD[0], "linear" )
			now+=STRIJD[0]
			@_timeout( =>
				@_scrollto( "strijd_2", STRIJD[1], "linear" )
			, now )
			now+=STRIJD[1]

			# pan through stryd
			@_timeout( =>
				@_scrollto( "strijd_3", STRIJD[2], "linear" )
			, now )
			now+=STRIJD[2]

			# climb through the window
			@_timeout( =>
				@_scrollto( "strijd_4", STRIJD[3], "easeInSine" )
			, now )
			now+=STRIJD[3]

			# jump down unto the dancefloor after a short break
			@_timeout( =>
				@_scrollto( "gala", STRIJD[4], "easeOutSine" )
			, now )
			now+=STRIJD[4]

			# show text
			@_timeout( =>
				@_showtext( "stryd" )
			, STRIJD_TEXT )

			@_timeout( =>
				@_gala()
			, now )

		_gala: ->
			@_current_scene = "gala";

			now = 0
			@_scrollto( @_current_scene )

			# pan through gala
			@_scrollto( "gala_1", GALA[0], "linear" )
			now+=GALA[0]

			# pan up
			@_timeout( =>
				@_scrollto( "gala_2", GALA[1], "linear" )
			, now )
			now+=GALA[1]

			# fade out
			@_timeout( =>
				@_fadeout_in( GALA[2] )
			, now-FADEOUT_DUR )
			now+=GALA[2]

			# show text
			@_timeout( =>
				@_showtext( "gala"
					reverse: true
				)
			, GALA_TEXT )

			@_timeout( =>
				@_dedebryunsz()
			, now )

		_dedebryunsz: ->
			@_current_scene = "dedebryunsz";

			now = 0
			@_scrollto( @_current_scene )

			# pan down brunch
			@_scrollto( "brunch_1", BRUNCH[0], "easeInOutSine" )
			now+=BRUNCH[0]

			# show text
			@_timeout( =>
				@_showtext( "dedebryunsz" 
					duration: 6000
				)
			, BRUNCH_TEXT )

			@_timeout( =>
				@_ctrl_replay()
			, now )
		###
			\Scene definitions
		###

		### @param target		target string of scene
			@param [options]	optional animation options ( consult jQuery.animate )
		###
		_showtext: ( target, options = {} ) ->
			# define default options
			defaults =
				duration: 5000
				reverse: false
			options = jQuery.extend( defaults, options )

			# direction of animated text
			h1Left = if options.reverse then "-=150" else "+=150"
			h2Left = if options.reverse then "+=150" else "-=150"

			# fade in text and animate titles in opposite directions
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

			# fade out text
			@_timeout( =>
				el.fadeTo( 400, 0 )
			, options.duration )

		###
			Helper functions
		###
		_scrollto: ( target, duration, callback ) ->
			jQuery.fn.scrollPath( "scrollTo", target, duration, callback )

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
		###
			\Helper functions
		###

		###
			Scrollpath init functions
		###
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
				.moveTo( P0.x, P0.y, { name: "intro" })
				.lineTo( P01.x, P01.y, { name: "intro_1" })

				# arrive with horse and carriage, go inside, to Tuesday: "LeO"
				.moveTo( P1.x, P1.y, { name: "leo" })
				.arc( C1.x, C1.y, C1.rad, PI/2, 0, true, { name: "leo_1" })
				.arc( C2.x, C2.y, C2.rad, 0, -PI/4, true, { name: "leo_2" } )

				# walk up the stairs, to Wednesday: "Recepski"
				.arc( C3.x, C3.y, C3.rad, 3/4*PI, PI, false, { name: "recepski" } )
				.arc( C4.x, C4.y, C4.rad, PI, -PI/2, false, { name: "recepski_1" })
				.arc( C5.x, C5.y, C5.rad, PI/2, -PI/2, true, { name: "recepski_2" })

				# continue up the stairs, to Thursday: "Letzing"
				.arc( C6.x, C6.y, C6.rad, PI/2, -PI/2, false, { name: "letszing" })

				# go outside, to the courtyard, down the stairs
				.arc( C7.x, C7.y, C7.rad, -PI/2, 0, false, { name: "courtyard" })
				.arc( C8.x, C8.y, C8.rad, PI, PI/2, true, { name: "courtyard_1" })

				# proceed to the courtyard, to Friday: "Tsar Wars"
				.arc( C9.x, C9.y, C9.rad, -PI/2, -PI/3, false, { name: "tsarwars" })
				.arc( C10.x, C10.y, C10.rad, PI/12*7, PI/2, true, { name: "tsarwars_1" })
				.lineTo( P2.x, P2.y, { name: "tsarwars_2" })

				# climb up the ladder, still Friday, but "Ekskursyi"
				.lineTo( P3.x, P3.y, { name: "ekskurzyi" })

				# enter the west wing, to Saturday: "Bruzjesdag"
				.lineTo( P4.x, P4.y, { name: "bruzjesdag" })

				# continue to the next room for Sunday: "Geszelschap Speylen Geszelschap"
				.lineTo( P5.x, P5.y, { name: "gsg" })
				.arc( C11.x, C11.y, C11.rad, -PI/2, 0, false, { name: "gsg_1" })

				# jump down the trapdoor, attending "Huishoudlijk Vergadring" on Monday
				.lineTo( P6.x, P6.y, { name: "hv" })
				.arc( C12.x, C12.y, C12.rad, -PI/2, -PI, true, { name: "hv_1" })

				# go down the stairs, to Tuesday: "Kabarat"
				.arc( C13.x, C13.y, C13.rad, PI, PI/2, true, { name: "kabarad" })
				.arc( C14.x, C14.y, C14.rad, PI/2, 0, true, { name: "kabarad_1" })

				# up the stairs again, to Wednesday: "Turbokring"
				.arc( C15.x, C15.y, C15.rad, 0, -PI/2, true, { name: "tyurbokring" })
				.lineTo( P7.x, P7.y, { name: "turbo_1" })
				# hop out the window, on the flagpole, balance a little
				.arc( C16.x, C16.y, C16.rad, -PI/8, -PI*3/4, true, { name: "turbo_2" })
				.lineTo( P8.x, P8.y, { name: "turbo_3" })
				.lineTo( P9.x, P9.y, { name: "turbo_4" })
				.lineTo( P10.x, P10.y, { name: "turbo_5" })
				.lineTo( P11.x, P11.y, { name: "turbo_6" })

				# take a huge leap and jump on the roof, to Thursday: "Stryd y Vertikalny"
				.arc( C17.x, C17.y, C17.rad, -PI/8, -PI*5/8, true, { name: "stryd" })
				.lineTo( P12.x, P12.y, { name: "strijd_1" })
				.lineTo( P13.x, P13.y, { name: "strijd_2" })
				.lineTo( P14.x, P14.y, { name: "strijd_3" })
				.arc( C18.x, C18.y, C18.rad, -PI*7/8, -PI/2, false, { name: "strijd_4" })

				# climb inside to the gala on Friday
				.arc( C19.x, C19.y, C19.rad, -PI*5/8, -PI/8, false, { name: "gala" })
				.arc( C20.x, C20.y, C20.rad, PI/2, 0, true, { name: "gala_1" })
				.lineTo( P15.x, P15.y, { name: "gala_2" })

				# transition to Saturday: "DeDe Bryunsz"
				.moveTo( P16.x, P16.y, { name: "dedebryunsz" })
				.lineTo( P17.x, P17.y, { name: "brunch_1" })
				
			# initiate ScrollPath on background image ( for real )
			jQuery( "div#background" ).scrollPath(
				scroll: false
				container: jQuery( "div#window" )
			)
		###
			\Scrollpath init functions
		###

		# Helper function to calculate the time for the beginning of a specific scene
		_get_music_ms: ( scene ) ->
			t = 0

			if scene is "intro" then return t
			t += BLACK_DUR + INTRO.reduce ( p, c ) -> p + c

			if scene is "leo" then return t
			t += LEO.reduce ( p, c ) -> p + c

			if scene is "recepski" then return t
			t += RECEPTIE.reduce ( p, c ) -> p + c

			if scene is "letszing" then return t
			t += LEZING.reduce ( p, c ) -> p + c

			if scene is "tsarwars" then return t
			t += TSARWARS.reduce ( p, c ) -> p + c

			if scene is "ekskurzyi" then return t
			t += EXCURSIE.reduce ( p, c ) -> p + c

			if scene is "bruzjesdag" then return t
			t += BRUSJES.reduce ( p, c ) -> p + c

			if scene is "gsg" then return t
			t += SPELLEN.reduce ( p, c ) -> p + c

			if scene is "hv" then return t
			t += HV.reduce ( p, c ) -> p + c

			if scene is "kabarad" then return t
			t += CABARET.reduce ( p, c ) -> p + c

			if scene is "tyurbokring" then return t
			t += TURBO.reduce ( p, c ) -> p + c

			if scene is "stryd" then return t
			t += STRIJD.reduce ( p, c ) -> p + c

			if scene is "gala" then return t
			t += FADEIN_DUR + GALA.reduce ( p, c ) -> p + c

			if scene is "dedebryunsz" then return t
			t += BRUNCH.reduce ( p, c ) -> p + c
			
			return t
