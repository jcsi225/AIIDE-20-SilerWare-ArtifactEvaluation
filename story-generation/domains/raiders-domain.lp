type(ark, item).
type(Weapon, item) :- type(Weapon, weapon).

positivefact(open(ark)).
positivefact(alive(Character)) :- type(Character, character).
positivefact(buried(Item, Place)) :- type(Item, item), type(Place, place).
positivefact(knowslocation(Character, Item, Place)) :- type(Character, character), type(Item, item), type(Place, place).
positivefact(at(Character, Place))  :- type(Character, character), type(Place, place).
positivefact(has(Character, Item))  :- type(Character, character), type(Item, item).
positivefact(armed(Character)) :- type(Character, character).

% A character travels from one place to another.
action(travel(Character,From,To)) :- type(Character, character), type(From, place), type(To, place), From != To.
actionprec(travel(Character,From,To),(
	alive(Character);
	at(Character,From)
		) ) :-  action(travel(Character,From,To)).
actionpost(travel(Character,From,To),(
	at(Character,To)
		) ) :- action(travel(Character,From,To)).
actionpost(travel(Character,From,To),(
	-at(Character,From)
		)) :- action(travel(Character,From,To)).
actionagent(travel(Character,From,To),Character) :- action(travel(Character,From,To)).

% A character excavates an item.
action(excavate(Character,Item,Place)) :- type(Character, character), type(Item, item), type(Place, place).
actionprec(excavate(Character,Item,Place),(
	alive(Character);
	at(Character, Place);
	buried(Item, Place);
	knowslocation(Character, Item, Place)
		) ) :-  action(excavate(Character,Item,Place)).
actionpost(excavate(Character,Item,Place),(	
	has(Character, Item)
		) ) :- action(excavate(Character,Item,Place)).
actionpost(excavate(Character,Item,Place),(	
	-buried(Item, Place)
		)) :- action(excavate(Character,Item,Place)).
actionagent(excavate(Character,Item,Place),Character) :- action(excavate(Character,Item,Place)).
		
% One character gives an item to another
action(give(Giver,Item,Receiver,Place)) :- type(Giver,character), type(Item,item), type(Receiver,character), type(Place,place), Giver != Receiver.
actionprec(give(Giver,Item,Receiver,Place),(
	alive(Giver);
	at(Giver,Place);
	has(Giver,Item);
	alive(Receiver);
	at(Receiver,Place)
		) ) :- action(give(Giver,Item,Receiver,Place)).
actionpost(give(Giver,Item,Receiver,Place),(
	has(Receiver,Item)
		) ) :- action(give(Giver,Item,Receiver,Place)).
actionpost(give(Giver,Item,Receiver,Place),(
	-has(Giver,Item)
		)) :- action(give(Giver,Item,Receiver,Place)).
actionagent(give(Giver,Item,Receiver,Place),(Giver;Receiver)) :- action(give(Giver,Item,Receiver,Place)).
		
% One character kills another.
action(kill(Killer,Weapon,Victim,Place)) :- type(Killer,character), type(Weapon,weapon), type(Victim,character), type(Place,place).
actionprec(kill(Killer,Weapon,Victim,Place),(
	alive(Killer);
	at(Killer,Place);
	has(Killer,Weapon);
	alive(Victim);
	at(Victim,Place)
		) ) :- action(kill(Killer,Weapon,Victim,Place)).
actionpost(kill(Killer,Weapon,Victim,Place),(
	-alive(Victim)
		)) :- action(kill(Killer,Weapon,Victim,Place)).
actionagent(kill(Killer,Weapon,Victim,Place),Killer) :- action(kill(Killer,Weapon,Victim,Place)).

% One character takes an item from another at weapon-point. [non-victim-dead branch of the disjunctive precondition of 'take' in original]
action(rob(Taker,Item,Victim,Place)) :- type(Taker,character), type(Item,item), type(Victim,character), type(Place,place), Taker != Victim.
actionprec(rob(Taker,Item,Victim,Place),(
	alive(Taker);
	alive(Victim);
	at(Taker,Place);
	armed(Taker);
	at(Victim,Place);
	has(Victim,Item)
		) ) :- action(rob(Taker,Item,Victim,Place)).
actionprec(rob(Taker,Item,Victim,Place),(
	-armed(Victim)
		)) :- action(rob(Taker,Item,Victim,Place)).
actionpost(rob(Taker,Item,Victim,Place),(
	has(Taker,Item)
		)) :- action(rob(Taker,Item,Victim,Place)).
actionpost(rob(Taker,Item,Victim,Place),(
	-has(Victim,Item)
		)) :- action(rob(Taker,Item,Victim,Place)).
actionagent(rob(Taker,Item,Victim,Place),Taker) :- action(rob(Taker,Item,Victim,Place)).

% [victim-dead branch of the disjunctive precondition of 'take' in original]
action(lootcorpse(Taker,Item,Victim,Place)) :- type(Taker,character), type(Item,item), type(Victim,character), type(Place,place), Taker != Victim.
actionprec(lootcorpse(Taker,Item,Victim,Place),(
	alive(Taker);
	at(Taker,Place);
	at(Victim,Place);
	has(Victim,Item)
		) ) :- action(lootcorpse(Taker,Item,Victim,Place)).
actionprec(lootcorpse(Taker,Item,Victim,Place),(
	-alive(Victim)
		)) :- action(lootcorpse(Taker,Item,Victim,Place)).
actionpost(lootcorpse(Taker,Item,Victim,Place),(
	has(Taker,Item)
		)) :- action(lootcorpse(Taker,Item,Victim,Place)).
actionpost(lootcorpse(Taker,Item,Victim,Place),(
	-has(Victim,Item)
		)) :- action(lootcorpse(Taker,Item,Victim,Place)).
actionagent(lootcorpse(Taker,Item,Victim,Place),Taker) :- action(lootcorpse(Taker,Item,Victim,Place)).

% A character opens the Ark.
action(openark(Character)) :- type(Character,character).
actionprec(openark(Character),(
	alive(Character);
	has(Character,ark)
		) ) :-  action(openark(Character)).
actionpost(openark(Character),(
	open(ark)
		)) :- action(openark(Character)).
actionpost(openark(Character),(
	-alive(Character)
		)) :- action(openark(Character)).
actionagent(openark(Character),Character) :- action(openark(Character)).

% The Ark closes.
action(closeark).
actionprec(closeark, open(ark)).
actionpost(closeark, -open(ark)).


axiom(armedrule(Character,Weapon)) :- type(Character,character), type(Weapon,weapon).
axiomprec(armedrule(Character,Weapon),(
	-armed(Character);
	has(Character,Weapon)
		) )	:- axiom(armedrule(Character,Weapon)).
axiompost(armedrule(Character,Weapon),armed(Character)) :- axiom(armedrule(Character,Weapon)).

axiom(unarmedrule(Character)) :- type(Character,character).
axiomprec(unarmedrule(Character),armed(Character)) :- axiom(unarmedrule(Character)).
axiomprec(unarmedrule(Character),-has(Character,Weapon)) :- type(Weapon,weapon), axiom(unarmedrule(Character)).
axiompost(unarmedrule(Character),-armed(Character)) :- axiom(unarmedrule(Character)).