Webstek - DiesCie Ipema 2012-2013 ( Russisch Royaal )
=====================================================
De source voor de webstek ter ere van de 51e Dies Natalis van Christelijke studentenvereniging Civitas Studiosorum Reformatorum.

Auteur: Adriaan Groenenboom (http://inkworks.nl)
Versie: 1.0 (20-01-2013)
Copyright 2013, Adriaan Groenenboom

Submodules
----------
Deze repo maakt gebruik van `git submodules`. Deze kunnen geinitialiseerd worden door de commando's `git submodule init` en vervolgens `git submodule update` aan te roepen. Raadpleeg de git handleiding voor meer info.

Gebruikte tools
---------------
### CoffeeScript
Een syntax alternatief voor JavaScript. De code is python-achtig en compilet naar JavaScript met behulp van het `coffee` commando:

	coffee --compile --watch .

__Noot: command-line tool installeren met ruby gem (zie meer info)__

Versie: 1.4.0
[Meer info](www.coffeescript.org)

### SASS (Syntactically Awesome StyleSheets)
Een syntax alternatief voor CSS. Geeft de mogelijkheid om variabelen en ingebouwde- en eigen functies (mixins) te gebruiken. Compilet naar CSS met het `sass` commando:

	sass --watch .:.

Versie: 3.2.5
[Meer info](www.sass-lang.com)

### RequireJS
Een JavaScript fileloader en module manager. Regelt closure en imports door middel van de functies `include` en `require`.

Locatie: vendor/require.js
Versie: 2.1.2
[Meer info](www.requirejs.org)

### jQuery
Een JavaScript library voor triviale en geavanceerde functies, waaronder event handling en DOM manipulatie.

Locatie: vendor/jQuery/
Versie: 1.9.0
[Meer info](www.jquery.com)

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

