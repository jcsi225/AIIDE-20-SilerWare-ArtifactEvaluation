type(
	indiana, character;
	nazis, character;
	army, character;
	usa, place;
	tanis, place;
	gun, weapon
		).
	
init((
	buried(ark, tanis);
	alive(indiana);
	at(indiana, usa);
	knowslocation(indiana, ark, tanis);
	intends(indiana,alive(indiana));
	intends(indiana,has(army,ark));
	alive(army);
	at(army, usa);
	intends(army,alive(army));
	intends(army,has(army,ark));
	alive(nazis);
	at(nazis, tanis);
	intends(nazis,alive(nazis));
	intends(nazis,open(ark));
	has(nazis, gun)	
		)).

goal((
	at(army, usa);
	has(army, ark)
		)).
goal(-alive(nazis)).
