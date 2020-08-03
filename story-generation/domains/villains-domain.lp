type(X,object) :- type(X,location).
type(X,object) :- type(X,actant).
type(X,actant) :- type(X,character).
type(X,actant) :- type(X,item).
type(X,character) :- type(X,hero).
type(X,character) :- type(X,villain).
type(X,character) :- type(X,guest).
type(X,hero) :- type(X,wizard).
type(X,hero) :- type(X,helper).
type(X,hero) :- type(X,prince).
type(X,hero) :- type(X,princess).
type(X,villain) :- type(X,witch).
type(X,villain) :- type(X,monster).
type(X,item) :- type(X,food).
type(X,item) :- type(X,weapon).
type(X,item) :- type(X,valuable).

% Constants (for efficiency, we commented out the ones that will never appear in a story for the sample problem)
%type(happy,helper).
%type(sleepy,helper).
%type(beast,prince).
type(charming,prince).
%type(belle,princess).
type(snow,princess).
type(grimhilde,witch).
type(maleficent,witch).
type(castle,location).
type(lair,location).
type(cottage,location).
type(forest,location).
type(town,location).
type(mines,location).
type(apple,food).
type(sword,weapon).
type(gold,valuable).


positivefact(hidden(A)) :- type(A,actant).
positivefact(at(A,L)) :- type(A,actant), type(L,location).
positivefact(alive(C)) :- type(C,character).
positivefact(married(C)) :- type(C,character).
positivefact(captured(C)) :- type(C,character).
positivefact(in_stasis(C)) :- type(C,character).
positivefact(has(C,I)) :- type(C,character), type(I,item).
positivefact(captured_by(C,Ec)) :- type(C,character), type(Ec,villain).
positivefact(loves(X,Y)) :- type(X,character), type(Y,character).
positivefact(invited_to(C,L)) :- type(C,character), type(L,location).
positivefact(married_to(X,Y)) :- type(X,character), type(Y,character).
positivefact(knows_location(C,L)) :- type(C,character), type(L,location).
positivefact(path(X,Y)) :- type(X,location), type(Y,location).
positivefact(poisoned(F)) :- type(F,food).
positivefact(island_in_stasis_snow).
positivefact(island_married_snow).


action(go(Character,From,To)) :- type(Character,character), type(From,location), type(To,location), From != To.
actionprec(go(Character,From,To), -in_stasis(Character)) :- action(go(Character,From,To)).
actionprec(go(Character,From,To), -captured(Character)) :- action(go(Character,From,To)).
actionprec(go(Character,From,To), alive(Character)) :- action(go(Character,From,To)).
actionprec(go(Character,From,To), at(Character,From)) :- action(go(Character,From,To)).
actionprec(go(Character,From,To), path(From,To)) :- action(go(Character,From,To)).
actionprec(go(Character,From,To), knows_location(Character,To)) :- action(go(Character,From,To)).
actionprec(go(Character,From,castle), invited_to(Character,castle)) :- action(go(Character,From,castle)).
actionpost(go(Character,From,To), -at(Character,From)) :- action(go(Character,From,To)).
actionpost(go(Character,From,To), at(Character,To)) :- action(go(Character,From,To)).
actionagent(go(Character,From,To),Character) :- action(go(Character,From,To)).

action(discover(Character,Actant,Location)) :- type(Character,character), type(Actant,actant), type(Location,location).
actionprec(discover(Character,Actant,Location), -in_stasis(Character)) :- action(discover(Character,Actant,Location)).
actionprec(discover(Character,Actant,Location), -captured(Character)) :- action(discover(Character,Actant,Location)).
actionprec(discover(Character,Actant,Location), hidden(Actant)) :- action(discover(Character,Actant,Location)).
actionprec(discover(Character,Actant,Location), alive(Character)) :- action(discover(Character,Actant,Location)).
actionprec(discover(Character,Actant,Location), at(Character,Location)) :- action(discover(Character,Actant,Location)).
actionprec(discover(Character,Actant,Location), at(Actant,Location)) :- action(discover(Character,Actant,Location)).
actionpost(discover(Character,Actant,Location), -hidden(Actant)) :- action(discover(Character,Actant,Location)).
actionagent(discover(Character,Actant,Location),Character) :- action(discover(Character,Actant,Location)).

action(poison(Character,Target,Location,Food)) :- type(Character,villain), type(Target,hero), type(Location,location), type(Food,food), Character != Target.
actionprec(poison(Character,Target,Location,Food), -in_stasis(Target)) :- action(poison(Character,Target,Location,Food)).
actionprec(poison(Character,Target,Location,Food), -hidden(Target)) :- action(poison(Character,Target,Location,Food)).
actionprec(poison(Character,Target,Location,Food), alive(Character)) :- action(poison(Character,Target,Location,Food)).
actionprec(poison(Character,Target,Location,Food), alive(Target)) :- action(poison(Character,Target,Location,Food)).
actionprec(poison(Character,Target,Location,Food), at(Character,Location)) :- action(poison(Character,Target,Location,Food)).
actionprec(poison(Character,Target,Location,Food), has(Character,Food)) :- action(poison(Character,Target,Location,Food)).
actionprec(poison(Character,Target,Location,Food), poisoned(Food)) :- action(poison(Character,Target,Location,Food)).
actionprec(poison(Character,Target,Location,Food), at(Target,Location)) :- action(poison(Character,Target,Location,Food)).
actionpost(poison(Character,Target,Location,Food), -has(Character,Food)) :- action(poison(Character,Target,Location,Food)).
actionpost(poison(Character,Target,Location,Food), -poisoned(Food)) :- action(poison(Character,Target,Location,Food)).
actionpost(poison(Character,Target,Location,Food), in_stasis(Target)) :- action(poison(Character,Target,Location,Food)).
actionconditionalpost(poison(Character,Target,Location,Food), loves(Admirer,Target), intends(Admirer,-in_stasis(Target))) :- action(poison(Character,Target,Location,Food)), type(Admirer,character).
actionagent(poison(Character,Target,Location,Food),Character) :- action(poison(Character,Target,Location,Food)).

action(capture(Character,Target,Location)) :- type(Character,villain), type(Target,hero), type(Location,location), Character != Target.
actionprec(capture(Character,Target,Location), -in_stasis(Character)) :- action(capture(Character,Target,Location)).
actionprec(capture(Character,Target,Location), -captured_by(Target,Character)) :- action(capture(Character,Target,Location)).
actionprec(capture(Character,Target,Location), -captured(Target)) :- action(capture(Character,Target,Location)).
actionprec(capture(Character,Target,Location), -hidden(Target)) :- action(capture(Character,Target,Location)).
actionprec(capture(Character,Target,Location), alive(Character)) :- action(capture(Character,Target,Location)).
actionprec(capture(Character,Target,Location), alive(Target)) :- action(capture(Character,Target,Location)).
actionprec(capture(Character,Target,Location), at(Character,Location)) :- action(capture(Character,Target,Location)).
actionprec(capture(Character,Target,Location), at(Target,Location)) :- action(capture(Character,Target,Location)).
actionpost(capture(Character,Target,Location), -at(Target,Location)) :- action(capture(Character,Target,Location)).
actionpost(capture(Character,Target,Location), captured_by(Target,Character)) :- action(capture(Character,Target,Location)).
actionpost(capture(Character,Target,Location), captured(Target)) :- action(capture(Character,Target,Location)).
actionconditionalpost(capture(Character,Target,Location), loves(Admirer,Target), intends(Admirer,-captured(Target))) :- action(capture(Character,Target,Location)), type(Admirer,character).
actionagent(capture(Character,Target,Location), Character) :- action(capture(Character,Target,Location)).

action(vanquish(Vanquisher,Target,Location,Weapon)) :- type(Vanquisher,hero), type(Target,villain), type(Location,location), type(Weapon,weapon), Vanquisher != Target.
actionprec(vanquish(Vanquisher,Target,Location,Weapon), -in_stasis(Vanquisher)) :- action(vanquish(Vanquisher,Target,Location,Weapon)).
actionprec(vanquish(Vanquisher,Target,Location,Weapon), -captured(Vanquisher)) :- action(vanquish(Vanquisher,Target,Location,Weapon)).
actionprec(vanquish(Vanquisher,Target,Location,Weapon), -hidden(Target)) :- action(vanquish(Vanquisher,Target,Location,Weapon)).
actionprec(vanquish(Vanquisher,Target,Location,Weapon), alive(Vanquisher)) :- action(vanquish(Vanquisher,Target,Location,Weapon)).
actionprec(vanquish(Vanquisher,Target,Location,Weapon), alive(Target)) :- action(vanquish(Vanquisher,Target,Location,Weapon)).
actionprec(vanquish(Vanquisher,Target,Location,Weapon), at(Vanquisher,Location)) :- action(vanquish(Vanquisher,Target,Location,Weapon)).
actionprec(vanquish(Vanquisher,Target,Location,Weapon), at(Vanquisher,Location)) :- action(vanquish(Vanquisher,Target,Location,Weapon)).
actionprec(vanquish(Vanquisher,Target,Location,Weapon), at(Target,Location)) :- action(vanquish(Vanquisher,Target,Location,Weapon)).
actionprec(vanquish(Vanquisher,Target,Location,Weapon), has(Vanquisher,Weapon)) :- action(vanquish(Vanquisher,Target,Location,Weapon)).
actionpost(vanquish(Vanquisher,Target,Location,Weapon),-alive(Target)) :- action(vanquish(Vanquisher,Target,Location,Weapon)).
actionconditionalpost(vanquish(Vanquisher,Target,Location,Weapon), and(captured(Captive),captured_by(Captive,Target)), -captured(Captive)) :- action(vanquish(Vanquisher,Target,Location,Weapon)), type(Captive,Character), Vanquisher != Captive.
actionconditionalpost(vanquish(Vanquisher,Target,Location,Weapon), and(captured(Captive),captured_by(Captive,Target)), -captured_by(Captive,Target)) :- action(vanquish(Vanquisher,Target,Location,Weapon)), type(Captive,Character), Vanquisher != Captive.
actionconditionalpost(vanquish(Vanquisher,Target,Location,Weapon), and(captured(Captive),captured_by(Captive,Target)), at(Captive,Location)) :- action(vanquish(Vanquisher,Target,Location,Weapon)), type(Captive,Character), Vanquisher != Captive.
actionconditionalpost(vanquish(Vanquisher,Target,Location,Weapon), and(captured(Captive),captured_by(Captive,Target)), loves(Captive,Vanquisher)) :- action(vanquish(Vanquisher,Target,Location,Weapon)), type(Captive,Character), Vanquisher != Captive.
actionconditionalpost(vanquish(Vanquisher,Target,Location,Weapon), has(Target,Item), -has(Target,Item)) :- action(vanquish(Vanquisher,Target,Location,Weapon)), type(Item,item).
actionconditionalpost(vanquish(Vanquisher,Target,Location,Weapon), has(Target,Item), at(Item,Location)) :- action(vanquish(Vanquisher,Target,Location,Weapon)), type(Item,item).
actionagent(vanquish(Vanquisher,Target,Location,Weapon),charming) :- action(vanquish(Vanquisher,Target,Location,Weapon)). % This is odd, possibly a typo in the original domain, but charming is the only possible Vanquisher in the sample problem anyways

action(kiss(Kisser,Kissee,Location)) :- type(Kisser,character), type(Kissee,character), type(Location,location), Kisser != Kissee.
actionprec(kiss(Kisser,Kissee,Location),-in_stasis(Kisser)) :- action(kiss(Kisser,Kissee,Location)).
actionprec(kiss(Kisser,Kissee,Location),-captured(Kissee)) :- action(kiss(Kisser,Kissee,Location)).
actionprec(kiss(Kisser,Kissee,Location),-captured(Kisser)) :- action(kiss(Kisser,Kissee,Location)).
actionprec(kiss(Kisser,Kissee,Location),alive(Kissee)) :- action(kiss(Kisser,Kissee,Location)).
actionprec(kiss(Kisser,Kissee,Location),alive(Kisser)) :- action(kiss(Kisser,Kissee,Location)).
actionprec(kiss(Kisser,Kissee,Location),at(Kisser,Location)) :- action(kiss(Kisser,Kissee,Location)).
actionprec(kiss(Kisser,Kissee,Location),at(Kissee,Location)) :- action(kiss(Kisser,Kissee,Location)).
actionprec(kiss(Kisser,Kissee,Location),in_stasis(Kissee)) :- action(kiss(Kisser,Kissee,Location)).
actionprec(kiss(Kisser,Kissee,Location),loves(Kissee,Kisser)) :- action(kiss(Kisser,Kissee,Location)).
actionprec(kiss(Kisser,Kissee,Location),loves(Kisser,Kissee)) :- action(kiss(Kisser,Kissee,Location)).
actionpost(kiss(Kisser,Kissee,Location),-in_stasis(Kissee)) :- action(kiss(Kisser,Kissee,Location)).
actionagent(kiss(Kisser,Kissee,Location),Kisser) :- action(kiss(Kisser,Kissee,Location)).

action(marry(Spouse1,Spouse2,Location)) :- type(Spouse1,character), type(Spouse2,character), type(Location,location), Spouse1 != Spouse2.
actionprec(marry(Spouse1,Spouse2,Location),-in_stasis(Spouse1)) :- action(marry(Spouse1,Spouse2,Location)).
actionprec(marry(Spouse1,Spouse2,Location),-in_stasis(Spouse2)) :- action(marry(Spouse1,Spouse2,Location)).
actionprec(marry(Spouse1,Spouse2,Location),-captured(Spouse1)) :- action(marry(Spouse1,Spouse2,Location)).
actionprec(marry(Spouse1,Spouse2,Location),-captured(Spouse2)) :- action(marry(Spouse1,Spouse2,Location)).
actionprec(marry(Spouse1,Spouse2,Location),alive(Spouse1)) :- action(marry(Spouse1,Spouse2,Location)).
actionprec(marry(Spouse1,Spouse2,Location),alive(Spouse2)) :- action(marry(Spouse1,Spouse2,Location)).
actionprec(marry(Spouse1,Spouse2,Location),at(Spouse1,Location)) :- action(marry(Spouse1,Spouse2,Location)).
actionprec(marry(Spouse1,Spouse2,Location),at(Spouse2,Location)) :- action(marry(Spouse1,Spouse2,Location)).
actionprec(marry(Spouse1,Spouse2,Location),loves(Spouse1,Spouse2)) :- action(marry(Spouse1,Spouse2,Location)).
actionprec(marry(Spouse1,Spouse2,Location),loves(Spouse2,Spouse1)) :- action(marry(Spouse1,Spouse2,Location)).
actionprec(marry(Spouse1,Spouse2,Location),-married_to(Spouse1,Spouse2)) :- action(marry(Spouse1,Spouse2,Location)).
actionprec(marry(Spouse1,Spouse2,Location),-married_to(Spouse2,Spouse1)) :- action(marry(Spouse1,Spouse2,Location)).
actionpost(marry(Spouse1,Spouse2,Location),married_to(Spouse1,Spouse2)) :- action(marry(Spouse1,Spouse2,Location)).
actionpost(marry(Spouse1,Spouse2,Location),married_to(Spouse2,Spouse1)) :- action(marry(Spouse1,Spouse2,Location)).
actionpost(marry(Spouse1,Spouse2,Location),married(Spouse1)) :- action(marry(Spouse1,Spouse2,Location)).
actionpost(marry(Spouse1,Spouse2,Location),married(Spouse2)) :- action(marry(Spouse1,Spouse2,Location)).
actionagent(marry(Spouse1,Spouse2,Location),Spouse1) :- action(marry(Spouse1,Spouse2,Location)).
actionagent(marry(Spouse1,Spouse2,Location),Spouse2) :- action(marry(Spouse1,Spouse2,Location)).


axiom(atlocationimpliesknowslocation(Character,Location)) :- type(Character,character), type(Location,location).
axiomprec(atlocationimpliesknowslocation(Character,Location),alive(Character)) :- axiom(atlocationimpliesknowslocation(Character,Location)).
axiomprec(atlocationimpliesknowslocation(Character,Location),at(Character,Location)) :- axiom(atlocationimpliesknowslocation(Character,Location)).
axiompost(atlocationimpliesknowslocation(Character,Location),knows_location(Character,Location)) :- axiom(atlocationimpliesknowslocation(Character,Location)).