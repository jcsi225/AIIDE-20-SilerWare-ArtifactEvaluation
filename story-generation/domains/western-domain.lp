type(X,living) :- type(X,person).
type(X,person) :- type(X,sheriff). % changed to a type (immutable predicate in PDDL)
type(X,living) :- type(X,animal).
type(X,item) :- type(X,animal).
type(X,item) :- type(X,valuable).
type(X,object) :- type(X,_).

type(jailhouse,place).
type(snakebite,sickness).

positivefact(alive(Person)) :- type(Person,person).
positivefact(free(Person)) :- type(Person,person).
positivefact(at(Object,Place)) :- type(Object,object), type(Place,place).
positivefact(belongsto(Item,Person)) :- type(Item,item), type(Person,person).
positivefact(has(Person,Item)) :- type(Person,person), type(Item,item).
positivefact(sick(Person,Sickness)) :- type(Person,person), type(Sickness,sickness).
positivefact(cures(Item,Sickness)) :- type(Item,item), type(Sickness,sickness).
positivefact(loves(Lover,Love)) :- type(Lover,person), type(Love,person).


action(snakebite(Victim)) :- type(Victim,person).
actionprec(snakebite(Victim), alive(Victim)) :- action(snakebite(Victim)).
actionpost(snakebite(Victim), sick(Victim,snakebite)) :- action(snakebite(Victim)).
actionpost(snakebite(Victim), intends(Victim,-sick(Victim,snakebite))) :- action(snakebite(Victim)).
actionconditionalpost(snakebite(Victim), loves(P,Victim), intends(P,-sick(Victim,snakebite))) :- action(snakebite(Victim)), type(P,person).

action(die(Person,Sickness)) :- type(Person,person), type(Sickness,sickness).
actionprec(die(Person,Sickness), alive(Person)) :- action(die(Person,Sickness)).
actionprec(die(Person,Sickness), sick(Person, Sickness)) :- action(die(Person,Sickness)).
actionpost(die(Person,Sickness), -alive(Person)) :- action(die(Person,Sickness)).

action(travel(Person,From,To)) :- type(Person,person), type(From,place), type(To,place).
actionprec(travel(Person,From,To), alive(Person)) :- action(travel(Person,From,To)).
actionprec(travel(Person,From,To), free(Person)) :- action(travel(Person,From,To)).
actionprec(travel(Person,From,To), at(Person,From)) :- action(travel(Person,From,To)).
actionpost(travel(Person,From,To), at(Person,To)) :- action(travel(Person,From,To)).
actionpost(travel(Person,From,To), -at(Person,From)) :- action(travel(Person,From,To)).
actionagent(travel(Person,From,To), Person) :- action(travel(Person,From,To)).


action(forcetravel(Person,Victim,From,To)) :- type(Person,person), type(Victim,person), type(From,place), type(To,place).
actionprec(forcetravel(Person,Victim,From,To), alive(Person)) :- action(forcetravel(Person,Victim,From,To)).
actionprec(forcetravel(Person,Victim,From,To), free(Person)) :- action(forcetravel(Person,Victim,From,To)).
actionprec(forcetravel(Person,Victim,From,To), at(Person,From)) :- action(forcetravel(Person,Victim,From,To)).
actionprec(forcetravel(Person,Victim,From,To), alive(Victim)) :- action(forcetravel(Person,Victim,From,To)).
actionprec(forcetravel(Person,Victim,From,To), -free(Victim)) :- action(forcetravel(Person,Victim,From,To)).
actionprec(forcetravel(Person,Victim,From,To), at(Victim,From)) :- action(forcetravel(Person,Victim,From,To)).
actionpost(forcetravel(Person,Victim,From,To), at(Person,To)) :- action(forcetravel(Person,Victim,From,To)).
actionpost(forcetravel(Person,Victim,From,To), -at(Person,From)) :- action(forcetravel(Person,Victim,From,To)).
actionpost(forcetravel(Person,Victim,From,To), at(Victim,To)) :- action(forcetravel(Person,Victim,From,To)).
actionpost(forcetravel(Person,Victim,From,To), -at(Victim,From)) :- action(forcetravel(Person,Victim,From,To)).
actionagent(forcetravel(Person,Victim,From,To), Person) :- action(forcetravel(Person,Victim,From,To)).

action(give(Giver,Receiver,Item,Place)) :- type(Giver,person), type(Receiver,person), type(Item,item), type(Place,place).
actionprec(give(Giver,Receiver,Item,Place), alive(Giver)) :- action(give(Giver,Receiver,Item,Place)).
actionprec(give(Giver,Receiver,Item,Place), free(Giver)) :- action(give(Giver,Receiver,Item,Place)).
actionprec(give(Giver,Receiver,Item,Place), at(Giver,Place)) :- action(give(Giver,Receiver,Item,Place)).
actionprec(give(Giver,Receiver,Item,Place), has(Giver,Item)) :- action(give(Giver,Receiver,Item,Place)).
actionprec(give(Giver,Receiver,Item,Place), alive(Receiver)) :- action(give(Giver,Receiver,Item,Place)).
actionprec(give(Giver,Receiver,Item,Place), free(Receiver)) :- action(give(Giver,Receiver,Item,Place)).
actionprec(give(Giver,Receiver,Item,Place), at(Receiver,Place)) :- action(give(Giver,Receiver,Item,Place)).
actionpost(give(Giver,Receiver,Item,Place), has(Giver,Item)) :- action(give(Giver,Receiver,Item,Place)).
actionpost(give(Giver,Receiver,Item,Place), -has(Receiver,Item)) :- action(give(Giver,Receiver,Item,Place)).
actionconditionalpost(give(Giver,Receiver,Item,Place), belongsto(Item,Giver), belongsto(Item,Receiver)) :- action(give(Giver,Receiver,Item,Place)).
actionagent(give(Giver,Receiver,Item,Place), Giver) :- action(give(Giver,Receiver,Item,Place)).
actionagent(give(Giver,Receiver,Item,Place), Receiver) :- action(give(Giver,Receiver,Item,Place)).

action(tieup(Person,Victim,Place)) :- type(Person,person), type(Victim,person), type(Place,place).
actionprec(tieup(Person,Victim,Place), alive(Person)) :- action(tieup(Person,Victim,Place)).
actionprec(tieup(Person,Victim,Place), free(Person)) :- action(tieup(Person,Victim,Place)).
actionprec(tieup(Person,Victim,Place), at(Person,Place)) :- action(tieup(Person,Victim,Place)).
actionprec(tieup(Person,Victim,Place), alive(Victim)) :- action(tieup(Person,Victim,Place)).
actionprec(tieup(Person,Victim,Place), at(Victim,Place)) :- action(tieup(Person,Victim,Place)).
actionpost(tieup(Person,Victim,Place), -free(Victim)) :- action(tieup(Person,Victim,Place)).
actionpost(tieup(Person,Victim,Place), intends(Victim,free(Victim))) :- action(tieup(Person,Victim,Place)).
actionagent(tieup(Person,Victim,Place), Person) :- action(tieup(Person,Victim,Place)).

action(untie(Person,Victim,Place))  :- type(Person,person), type(Victim,person), type(Place,place).
actionprec(untie(Person,Victim,Place), alive(Person)) :- action(untie(Person,Victim,Place)).
actionprec(untie(Person,Victim,Place), free(Person)) :- action(untie(Person,Victim,Place)).
actionprec(untie(Person,Victim,Place), at(Person,Place)) :- action(untie(Person,Victim,Place)).
actionprec(untie(Person,Victim,Place), alive(Victim)) :- action(untie(Person,Victim,Place)).
actionprec(untie(Person,Victim,Place), -free(Victim)) :- action(untie(Person,Victim,Place)).
actionprec(untie(Person,Victim,Place), at(Victim,Place)) :- action(untie(Person,Victim,Place)).
actionpost(untie(Person,Victim,Place), free(Victim)) :- action(untie(Person,Victim,Place)).
actionagent(untie(Person,Victim,Place), Person) :- action(untie(Person,Victim,Place)).

action(take(Taker,Item,Victim,Place)) :- type(Taker,person), type(Item,item), type(Victim,person),type(Place,place), Taker != Victim.
actionprec(take(Taker,Item,Victim,Place), alive(Taker)) :- action(take(Taker,Item,Victim,Place)).
actionprec(take(Taker,Item,Victim,Place), free(Taker)) :- action(take(Taker,Item,Victim,Place)).
actionprec(take(Taker,Item,Victim,Place), at(Taker,Place)) :- action(take(Taker,Item,Victim,Place)).
actionprec(take(Taker,Item,Victim,Place), alive(Victim)) :- action(take(Taker,Item,Victim,Place)).
actionprec(take(Taker,Item,Victim,Place), -free(Victim)) :- action(take(Taker,Item,Victim,Place)).
actionprec(take(Taker,Item,Victim,Place), at(Victim,Place)) :- action(take(Taker,Item,Victim,Place)).
actionprec(take(Taker,Item,Victim,Place), has(Victim,Item)) :- action(take(Taker,Item,Victim,Place)).
actionpost(take(Taker,Item,Victim,Place), has(Taker,Item)) :- action(take(Taker,Item,Victim,Place)).
actionpost(take(Taker,Item,Victim,Place), -has(Victim,Item)) :- action(take(Taker,Item,Victim,Place)).
actionconditionalpost(take(Taker,Item,Victim,Place), belongsto(Item,Victim), intends(Victim,has(Victim,Item))) :- action(take(Taker,Item,Victim,Place)).
actionconditionalpost(take(Taker,Item,Victim,Place), belongsto(Item,Victim), 
	intends(S, and( at(Taker,jailhouse), 
				and( -free(Taker),
					and( has(Victim,Item),
						free(Victim))))))
		:- action(take(Taker,Item,Victim,Place)), type(S,sheriff).
actionagent(take(Taker,Item,Victim,Place), Taker) :- action(take(Taker,Item,Victim,Place)).


action(heal(Healer,Patient,Sickness,Medicine,Place)) :- type(Healer,person), type(Patient,person), type(Sickness,sickness), type(Medicine,item), type(Place,place).
actionprec(heal(Healer,Patient,Sickness,Medicine,Place), cures(Medicine,Sickness)) :- action(heal(Healer,Patient,Sickness,Medicine,Place)).
actionprec(heal(Healer,Patient,Sickness,Medicine,Place), alive(Healer)) :- action(heal(Healer,Patient,Sickness,Medicine,Place)).
actionprec(heal(Healer,Patient,Sickness,Medicine,Place), free(Healer)) :- action(heal(Healer,Patient,Sickness,Medicine,Place)).
actionprec(heal(Healer,Patient,Sickness,Medicine,Place), at(Healer,Place)) :- action(heal(Healer,Patient,Sickness,Medicine,Place)).
actionprec(heal(Healer,Patient,Sickness,Medicine,Place), has(Healer,Medicine)) :- action(heal(Healer,Patient,Sickness,Medicine,Place)).
actionprec(heal(Healer,Patient,Sickness,Medicine,Place), alive(Patient)) :- action(heal(Healer,Patient,Sickness,Medicine,Place)).
actionprec(heal(Healer,Patient,Sickness,Medicine,Place), at(Patient,Place)) :- action(heal(Healer,Patient,Sickness,Medicine,Place)).
actionprec(heal(Healer,Patient,Sickness,Medicine,Place), sick(Patient,Sickness)) :- action(heal(Healer,Patient,Sickness,Medicine,Place)).
actionpost(heal(Healer,Patient,Sickness,Medicine,Place), -sick(Patient,Sickness)) :- action(heal(Healer,Patient,Sickness,Medicine,Place)).
actionpost(heal(Healer,Patient,Sickness,Medicine,Place), -has(Healer,Medicine)) :- action(heal(Healer,Patient,Sickness,Medicine,Place)).
actionagent(heal(Healer,Patient,Sickness,Medicine,Place), Healer) :- action(heal(Healer,Patient,Sickness,Medicine,Place)).
actionagent(heal(Healer,Patient,Sickness,Medicine,Place), Patient) :- action(heal(Healer,Patient,Sickness,Medicine,Place)).