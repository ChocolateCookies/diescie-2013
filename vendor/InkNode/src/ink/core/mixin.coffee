define [], ->
	
	# utility method for mixing in a class
	# into another base class for extension
	#
	# @note use like this `class A extends mixin( BaseClass, mixins... )`
	# @param cls {Class} Base Class
	# @param protos {Class...} One or more mixin classes
	mixin = ( cls, protos... ) ->
		
		# create a new class that extends the base
		class Mixin extends cls
			
			# chain the constructor
			constructor: ( args... ) ->
				super( args... )

				# call the mixin constructors
				# without arguments
				for proto in protos
					proto::constructor.call( this )

		# create the prototype of the new class
		# from the mixin's prototypes
		for proto in protos
			# copy everything from the mixin
			# to the class prototype
			for own key, val of proto.prototype
				if key isnt "constructor"
					Mixin.prototype[ key ] = val

		# return the created class
		return Mixin
