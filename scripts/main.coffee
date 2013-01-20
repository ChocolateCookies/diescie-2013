
require.config
	baseUrl : "scripts"
	paths:
		"jQuery/jQuery" : "vendor/jquery-1.9.0",
		"jQuery/ScrollPath" : "vendor/jQueryScrollPath/script/jquery.scrollpath",
		"jQuery/Easing" : "vendor/jQueryEasing/jquery.easing.1.3",
		"jQuery/Pause" : "vendor/jQueryPause/jquery.pause.min",
		"jQuery/HashChange" : "vendor/jQueryHashChange/jquery.ba-hashchange",
		"jQuery/WaitForImages" : "vendor/jQueryWaitForImages/src/jquery.waitforimages",
	shim:
		"jQuery/ScrollPath":
			deps: [ "jQuery/jQuery" ]
			exports: "jQuery.fn.scrollPath"
		"jQuery/Easing":
			deps: [ "jQuery/jQuery" ]
		"jQuery/HashChange":
			deps: [ "jQuery/jQuery" ]
		"jQuery/WaitForImages":
			deps: [ "jQuery/jQuery" ]
