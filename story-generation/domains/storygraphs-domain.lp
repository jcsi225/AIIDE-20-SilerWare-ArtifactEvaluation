type(Humanoid, character) :- type(Humanoid, humanoid). % deprecated
type(Merchant,humanoid) :- type(Merchant,merchant).
type(Guard,humanoid) :- type(Guard,guard).
type(Money,item) :- type(Money,money).
type(Weapon,item) :- type(Weapon,weapon).


positivefact(alive(Character)) :- type(Character,character).
positivefact(armed(Character)) :- type(Character,character).
positivefact(path(From,To)) :- type(From,location), type(To,location).
positivefact(at(Character,Location)) :- type(Character,character), type(Location,location).
positivefact(at(Item,Location)) :- type(Item,item), type(Location,location).
positivefact(knows_location(Character,Location)) :-  type(Character,character), type(Location,location).
positivefact(has(Character,Item)) :-  type(Character,character), type(Item,item).
positivefact(criminal(Character)) :- type(Character,character).

action(walk(Character,From,To)) :- type(Character,character), type(From,location), type(To,location), From != To.
actionprec(walk(Character,From,To),
	alive(Character) ) :- action(walk(Character,From,To)).
actionprec(walk(Character,From,To),
	at(Character,From) ) :- action(walk(Character,From,To)).
actionprec(walk(Character,From,To),
	path(From,To) ) :- action(walk(Character,From,To)).
actionprec(walk(Character,From,To),
	knows_location(Character,To) ) :- action(walk(Character,From,To)).
% Disjunctive precondition handled via the additional predicate below
actionpost(walk(Character,From,To),
	-at(Character,From) ) :- action(walk(Character,From,To)).
actionpost(walk(Character,From,To),
	at(Character,To) ) :- action(walk(Character,From,To)).
actionagent(walk(Character,From,To),Character) :- action(walk(Character,From,To)).

action(rob(Character,Item,Victim,Location)) :- type(Character,character), type(Victim,character), type(Location,location), type(Item,item), Character != Victim.
actionprec(rob(Character,Item,Victim,Location),
	alive(Character) ) :- action(rob(Character,Item,Victim,Location)).
actionprec(rob(Character,Item,Victim,Location),
	alive(Victim) ) :- action(rob(Character,Item,Victim,Location)).
actionprec(rob(Character,Item,Victim,Location),
	at(Character,Location) ) :- action(rob(Character,Item,Victim,Location)).
actionprec(rob(Character,Item,Victim,Location),
	at(Victim,Location) ) :- action(rob(Character,Item,Victim,Location)).
actionprec(rob(Character,Item,Victim,Location),
	armed(Character) ) :- action(rob(Character,Item,Victim,Location)).
actionprec(rob(Character,Item,Victim,Location),
	-armed(Victim) ) :- action(rob(Character,Item,Victim,Location)).
actionprec(rob(Character,Item,Victim,Location),
	has(Victim,Item) ) :- action(rob(Character,Item,Victim,Location)).
actionpost(rob(Character,Item,Victim,Location),
	has(Character,Item) ) :- action(rob(Character,Item,Victim,Location)).
actionpost(rob(Character,Item,Victim,Location),
	-has(Victim,Item) ) :- action(rob(Character,Item,Victim,Location)).
actionconditionalpost(rob(Character,Item,Victim,Location),-criminal(Victim),criminal(Character)) :- action(rob(Character,Item,Victim,Location)).
actionagent(rob(Character,Item,Victim,Location),Character) :- action(rob(Character,Item,Victim,Location)).

% Split from the 'attack' action with conditional effects --- attacker armed (successful kill) --- unlawful version
action(attack(Character,Target,Location)) :- type(Character,character), type(Target,character), type(Location,location), Character != Target.
actionprec(attack(Character,Target,Location),
	alive(Character) ) :- action(attack(Character,Target,Location)).
actionprec(attack(Character,Target,Location),
	at(Character,Location) ) :- action(attack(Character,Target,Location)).
actionprec(attack(Character,Target,Location),
	alive(Target) ) :- action(attack(Character,Target,Location)).
actionprec(attack(Character,Target,Location),
	at(Target,Location) ) :- action(attack(Character,Target,Location)).
actionprec(attack(Character,Target,Location),
	or(armed(Character),-armed(Target))) :- action(attack(Character,Target,Location)).
actionpost(attack(Character,Target,Location),
	-alive(Target) ) :- action(attack(Character,Target,Location)).
actionagent(attack(Character,Target,Location),Character) :- action(attack(Character,Target,Location)).
actionconditionalpost(attack(Character,Target,Location),-criminal(Target),criminal(Character)) :- action(attack(Character,Target,Location)).
	
action(pickup(Character,Item,Location)) :- type(Character,character), type(Item,item), type(Location,location).
actionprec(pickup(Character,Item,Location),
	alive(Character) ) :- action(pickup(Character,Item,Location)).
actionprec(pickup(Character,Item,Location),
	at(Character,Location) ) :- action(pickup(Character,Item,Location)).
actionprec(pickup(Character,Item,Location),
	at(Item,Location) ) :- action(pickup(Character,Item,Location)).
actionpost(pickup(Character,Item,Location),
	-at(Item,Location) ) :- action(pickup(Character,Item,Location)).
actionpost(pickup(Character,Item,Location),
	has(Character,Item) ) :- action(pickup(Character,Item,Location)).
actionagent(pickup(Character,Item,Location),Character) :- action(pickup(Character,Item,Location)).

action(buy(Character,Item,Seller,Coin,Location)) :- type(Character,character), type(Coin,money), type(Seller,merchant), type(Item,item), type(Location,location). 
actionprec(buy(Character,Item,Seller,Coin,Location),
	alive(Character)) :- action(buy(Character,Item,Seller,Coin,Location)).
actionprec(buy(Character,Item,Seller,Coin,Location),
	alive(Seller)) :- action(buy(Character,Item,Seller,Coin,Location)).
actionprec(buy(Character,Item,Seller,Coin,Location),
	at(Character,Location)) :- action(buy(Character,Item,Seller,Coin,Location)).
actionprec(buy(Character,Item,Seller,Coin,Location),
	at(Seller,Location)) :- action(buy(Character,Item,Seller,Coin,Location)).
actionprec(buy(Character,Item,Seller,Coin,Location),
	has(Character,Coin)) :- action(buy(Character,Item,Seller,Coin,Location)).
actionprec(buy(Character,Item,Seller,Coin,Location),
	has(Seller,Item)) :- action(buy(Character,Item,Seller,Coin,Location)).
actionpost(buy(Character,Item,Seller,Coin,Location),
	-has(Character,Coin)) :- action(buy(Character,Item,Seller,Coin,Location)).
actionpost(buy(Character,Item,Seller,Coin,Location),
	has(Seller,Coin)) :- action(buy(Character,Item,Seller,Coin,Location)).
actionpost(buy(Character,Item,Seller,Coin,Location),
	-has(Seller,Item)) :- action(buy(Character,Item,Seller,Coin,Location)).
actionpost(buy(Character,Item,Seller,Coin,Location),
	has(Character,Item)) :- action(buy(Character,Item,Seller,Coin,Location)).
actionagent(buy(Character,Item,Seller,Coin,Location),Character) :- action(buy(Character,Item,Seller,Coin,Location)).
actionagent(buy(Character,Item,Seller,Coin,Location),Seller) :- action(buy(Character,Item,Seller,Coin,Location)).


% When a character dies, they drop all their items.
axiom(deathitemdrop(Character,Item,Location)) :- type(Character,character), type(Item,item), type(Location,location).
axiomprec(deathitemdrop(Character,Item,Location),
	-alive(Character) ) :- axiom(deathitemdrop(Character,Item,Location)).
axiomprec(deathitemdrop(Character,Item,Location),
	at(Character,Location) ) :- axiom(deathitemdrop(Character,Item,Location)).
axiomprec(deathitemdrop(Character,Item,Location),
	has(Character,Item) ) :- axiom(deathitemdrop(Character,Item,Location)).
axiompost(deathitemdrop(Character,Item,Location),
	-has(Character,Item) ) :- axiom(deathitemdrop(Character,Item,Location)).
axiompost(deathitemdrop(Character,Item,Location),
	at(Item,Location) ) :- axiom(deathitemdrop(Character,Item,Location)).
	
% When a character has a weapon, they are armed.
axiom(armedrule(Character,Weapon)) :- type(Character,character), type(Weapon,weapon).
axiomprec(armedrule(Character,Weapon),(
	-armed(Character);
	has(Character,Weapon)
		) )	:- axiom(armedrule(Character,Weapon)).
axiompost(armedrule(Character,Weapon),armed(Character)) :- axiom(armedrule(Character,Weapon)).

% When a character has no weapon, they are unarmed.
axiom(unarmedrule(Character)) :- type(Character,character).
axiomprec(unarmedrule(Character),armed(Character)) :- axiom(unarmedrule(Character)).
axiomprec(unarmedrule(Character),-has(Character,Weapon)) :- type(Weapon,weapon), axiom(unarmedrule(Character)).
axiompost(unarmedrule(Character),-armed(Character)) :- axiom(unarmedrule(Character)).

% A guard wants to kill criminals.
axiom(guardkillcriminals(Character,Guard)) :- type(Character,character), type(Guard,guard).
axiomprec(guardkillcriminals(Character,Guard),alive(Character)) :- axiom(guardkillcriminals(Character,Guard)).
axiomprec(guardkillcriminals(Character,Guard),criminal(Character)) :- axiom(guardkillcriminals(Character,Guard)).
axiomprec(guardkillcriminals(Character,Guard),alive(Guard)) :- axiom(guardkillcriminals(Character,Guard)).
axiompost(guardkillcriminals(Character,Guard),intends(Guard,-alive(Character))) :- axiom(guardkillcriminals(Character,Guard)).