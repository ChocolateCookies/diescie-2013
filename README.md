Webstek - DiesCie Ipema 2012-2013 ( Russisch Royaal )
=====================================================
De source voor de webstek ter ere van de 51e Dies Natalis van Christelijke studentenvereniging Civitas Studiosorum Reformatorum.

Auteur: Adriaan Groenenboom (http://inkworks.nl)

Versie: 1.0 (20-01-2013)

Copyright 2013, Adriaan Groenenboom

Submodules
----------
Deze repo maakt gebruik van `git submodules`. 
Deze kunnen geinitialiseerd worden door de commando's `git submodule init` en vervolgens `git submodule update` aan te roepen. 
Raadpleeg de [git handleiding](http://git-scm.com/book/en/Git-Tools-Submodules) voor meer info.

Gebruikte tools
---------------
### CoffeeScript
Een syntax alternatief voor JavaScript. De code is python-achtig en compilet naar JavaScript met behulp van het `coffee` commando:

	coffee --compile --watch .

__Noot: command-line tool installeren met ruby gem (zie meer info)__

Versie: 1.4.0

[Meer info](http://www.coffeescript.org)

### SASS (Syntactically Awesome StyleSheets)
Een syntax alternatief voor CSS. 
Deze geeft de mogelijkheid om variabelen en ingebouwde- en eigen functies (mixins) te gebruiken. 
Compilet naar CSS met het `sass` commando:

	sass --watch .:.

__Noot: Om het project te builden is de command-line tool nodig, te installeren via de package manager van de linux distro.__

Versie: 3.2.5

[Meer info](http://www.sass-lang.com)

### RequireJS
Een JavaScript fileloader en module manager. Regelt closure en imports door middel van de functies `define` en `require`.

__Noot: Om het project te builden is een command-line tool nodig, te installeren met het volgende commando:__

	npm install -g requirejs

Locatie: vendor/require.js

Versie: 2.1.2

[Meer info](http://www.requirejs.org)

### jQuery
Een JavaScript library voor triviale en geavanceerde functies, waaronder event handling en DOM manipulatie.

Locatie: vendor/jquery-1.9.0.js

Versie: 1.9.0

[Meer info](http://www.jquery.com)

Gebruikte jQuery plugins
-----------------
### jQueryHashChange
Implementeert een eenvoudige bookmarkable geschiedenis en event handling op basis van window.location.hash, te zien als een string achter het hash (#) teken in de adresbalk.

Locatie: vendor/jQueryHashChange/

Versie: 1.3

[Meer info](https://github.com/cowboy/jquery-hashchange/tree/v1.3)

### jQueryScrollPath
Een jQuery plugin waarmee een pad gedefinieerd kan worden waar de browser overheen scrollt of animeert.

Locatie: vendor/jQueryScrollPath/

Versie: 1.1.1 (forked & editted, zie commit messages)

[Meer info (forked & editted)](https://github.com/inkworks/scrollpath.git)

[Meer info (origineel)](https://github.com/JoelBesada/scrollpath)

### jQueryWaitForImages
Een jQuery plugin die het laden van afbeeldingen regelt. Een event wordt getriggert zodra alle <img> en CSS sources geladen zijn.

Locatie: vendor/jQueryWaitForImages/

Versie: 1.4.2

[Meer info](https://github.com/alexanderdickson/waitForImages.git)

Builden
-------
De RequireJS library importeert de JS files als modules. De development werkt met andere files dan de production versie. 

__Noot: om het wisselen tussen development en production makkelijk te maken, zijn de tags al in index.html opgenomen.
Het enige wat u hoeft te doen, is de comment tags (<!-- -->) weg te halen, zodat de juiste modus geactiveerd wordt.__

Lees verder voor gedetaileerde uitleg.

### Development
Alle files nodig voor development zitten vanaf de root directory, met uitzondering van de build/ directory. 
Omdat RequireJS geimporteert moet worden, is de volgende tag in de head van index.html opgenomen:
	
	<script src='vendor/require.js' data-main='scripts/main'></script>

Deze neemt RequireJS op en met de data-main property wordt `scripts/main.js` aangeroepen als main functie.
In scripts/main.coffee wordt RequireJS geconfigureerd (zie de [online RequireJS docs](http://www.requirejs.org/docs/optimization.html#basics) voor meer info)

Daarna wordt de werkelijke main functie geimporteerd door de volgende script:

	<script> require([ "main_index" ], function() {});</script>

### Production & deployment
Voor de productiefase moeten alle CoffeeScript en SASS files naar een enkel bestand gebuild worden.
Hier komt de `require.js` command-line utility geinstalleerd met `npm` bij kijken, alsmede het `sass` commando.

__Noot: Om het builden en deployen makkelijk te maken is er een deploy.sh script in de repo opgenomen. 
Door ./deploy.sh uit te voeren, wordt er een build/ folder aangemaakt waar alle nodige bestanden in staan die de webserver nodig heeft.__

Lees verder voor gedetaileerde uitleg.

Het builden van de SASS files geschiedt met het volgende commando in de `styles` directory:
	
	sass main.scss:main.css

Het builden van de CoffeeScript files geschiedt met het volgende commando:

	coffee --compile scripts/

Om alle JavaScript modules in een file te zetten, wordt het volgende commando uitgevoerd 
(zie de [online RequireJS docs](http://www.requirejs.org/docs/optimization.html#basics) voor meer info):

	r.js -o baseUrl='scripts/' name='main_index' out='scripts/main_index-built.js' mainConfigFile='scripts/main.js'

De manier van scripts importeren verandert door het gebruik van een JS file in plaats van meerdere files.
Hiertoe moet index.html aangepast worden.
De HTML code lijkt sterk op die van de development fase, met uitzondering van een paar subtiele verschillen.
RequireJS is nog steeds nodig, maar de het main script hoeft niet meer aangegeven te worden, want deze wordt direct geimporteerd.
De development code wordt zo dus vervangen door de volgende regels:

		<script src='vendor/require.js'></script>
		<script src='scripts/main_index-built.js'></script>
	
In `scripts/main_index-build.js` staat het gehele script, inclusief alle benodigde modules en de main procedure.

