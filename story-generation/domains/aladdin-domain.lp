type(X,object) :- type(X,character).
type(X,object) :- type(X,thing).
type(X,object) :- type(X,place).
type(X,character) :- type(X,male).
type(X,character) :- type(X,female).
type(X,character) :- type(X,monster).
type(X,male) :- type(X,knight).
type(X,male) :- type(X,king).
type(X,monster) :- type(X,genie).
type(X,monster) :- type(X,dragon).
type(X,thing) :- type(X,magic_lamp).

positivefact(alive(Character)) :- type(Character,character).
positivefact(scary(Monster)) :- type(Monster,monster).
positivefact(beautiful(Character)) :- type(Character,character).
positivefact(confined(Character)) :- type(Character,character).
positivefact(single(Character)) :- type(Character,character).
positivefact(married(Character)) :- type(Character,character).
positivefact(at(Character,Place)) :- type(Character,character), type(Place,place).
positivefact(in(Genie,Magic_Lamp)) :- type(Genie,genie), type(Magic_Lamp,magic_lamp).
positivefact(has(Character,Thing)) :- type(Character,character), type(Thing,thing).
positivefact(loyal_to(Knight,King)) :- type(Knight,knight), type(King,king).
positivefact(controls(Character,Genie)) :- type(Character,character), type(Genie,genie).
positivefact(loves(Lover,Love_Interest)) :- type(Lover,character), type(Love_Interest,character).
positivefact(married_to(Character1,Character2)) :- type(Character1,character), type(Character2,character).

action(go(Character,From,To)) :- type(Character,character), type(From,place), type(To,place), From != To.
actionprec(go(Character,From,To), alive(Character)) :- action(go(Character,From,To)).
actionprec(go(Character,From,To), at(Character,From)) :- action(go(Character,From,To)).
actionpost(go(Character,From,To), -at(Character,From)) :- action(go(Character,From,To)).
actionpost(go(Character,From,To), at(Character,To)) :- action(go(Character,From,To)).
actionagent(go(Character,From,To),Character) :- action(go(Character,From,To)).

action(slay(Knight,Monster,Place)) :- type(Knight,knight), type(Monster,monster), type(Place,place).
actionprec(slay(Knight,Monster,Place), alive(Knight)) :- action(slay(Knight,Monster,Place)).
actionprec(slay(Knight,Monster,Place), at(Knight,Place)) :- action(slay(Knight,Monster,Place)).
actionprec(slay(Knight,Monster,Place), alive(Monster)) :- action(slay(Knight,Monster,Place)).
actionprec(slay(Knight,Monster,Place), at(Monster,Place)) :- action(slay(Knight,Monster,Place)).
actionpost(slay(Knight,Monster,Place), -alive(Monster)) :- action(slay(Knight,Monster,Place)).
actionagent(slay(Knight,Monster,Place),Knight) :- action(slay(Knight,Monster,Place)).

action(pillage(Pillager,Victim,Thing,Place)) :- type(Pillager,character), type(Victim,character), type(Thing,thing), type(Place,place).
actionprec(pillage(Pillager,Victim,Thing,Place), alive(Pillager)) :- action(pillage(Pillager,Victim,Thing,Place)).
actionprec(pillage(Pillager,Victim,Thing,Place), at(Pillager,Place)) :- action(pillage(Pillager,Victim,Thing,Place)).
actionprec(pillage(Pillager,Victim,Thing,Place), -alive(Victim)) :- action(pillage(Pillager,Victim,Thing,Place)).
actionprec(pillage(Pillager,Victim,Thing,Place), at(Victim,Place)) :- action(pillage(Pillager,Victim,Thing,Place)).
actionprec(pillage(Pillager,Victim,Thing,Place), has(Victim,Thing)) :- action(pillage(Pillager,Victim,Thing,Place)).
actionpost(pillage(Pillager,Victim,Thing,Place), -has(Victim,Thing)) :- action(pillage(Pillager,Victim,Thing,Place)).
actionpost(pillage(Pillager,Victim,Thing,Place), has(Pillager,Thing)) :- action(pillage(Pillager,Victim,Thing,Place)).
actionagent(pillage(Pillager,Victim,Thing,Place),Pillager) :- action(pillage(Pillager,Victim,Thing,Place)).

action(give(Giver,Recipient,Thing,Place)) :- type(Giver,character), type(Recipient,character), type(Thing,thing),type(Place,place), Giver != Recipient.
actionprec(give(Giver,Recipient,Thing,Place), alive(Giver)) :- action(give(Giver,Recipient,Thing,Place)).
actionprec(give(Giver,Recipient,Thing,Place), at(Giver,Place)) :- action(give(Giver,Recipient,Thing,Place)).
actionprec(give(Giver,Recipient,Thing,Place), has(Giver,Thing)) :- action(give(Giver,Recipient,Thing,Place)).
actionprec(give(Giver,Recipient,Thing,Place), alive(Recipient)) :- action(give(Giver,Recipient,Thing,Place)).
actionprec(give(Giver,Recipient,Thing,Place), at(Recipient,Place)) :- action(give(Giver,Recipient,Thing,Place)).
actionpost(give(Giver,Recipient,Thing,Place), -has(Giver,Thing)) :- action(give(Giver,Recipient,Thing,Place)).
actionpost(give(Giver,Recipient,Thing,Place), has(Recipient,Thing)) :- action(give(Giver,Recipient,Thing,Place)).
actionagent(give(Giver,Recipient,Thing,Place),Giver) :- action(give(Giver,Recipient,Thing,Place)).

action(summon(Character,Genie,Lamp,Place)) :- type(Character,character), type(Genie,genie), type(Lamp,magic_lamp), type(Place,place).
actionprec(summon(Character,Genie,Lamp,Place), alive(Character)) :- action(summon(Character,Genie,Lamp,Place)).
actionprec(summon(Character,Genie,Lamp,Place), at(Character,Place)) :- action(summon(Character,Genie,Lamp,Place)).
actionprec(summon(Character,Genie,Lamp,Place), has(Character,Lamp)) :- action(summon(Character,Genie,Lamp,Place)).
actionprec(summon(Character,Genie,Lamp,Place), alive(Genie)) :- action(summon(Character,Genie,Lamp,Place)).
actionprec(summon(Character,Genie,Lamp,Place), in(Genie,Lamp)) :- action(summon(Character,Genie,Lamp,Place)).
actionpost(summon(Character,Genie,Lamp,Place), -confined(Genie)) :- action(summon(Character,Genie,Lamp,Place)).
actionpost(summon(Character,Genie,Lamp,Place), -in(Genie,Lamp)) :- action(summon(Character,Genie,Lamp,Place)).
actionpost(summon(Character,Genie,Lamp,Place), at(Genie,Place)) :- action(summon(Character,Genie,Lamp,Place)).
actionpost(summon(Character,Genie,Lamp,Place), controls(Character,Genie)) :- action(summon(Character,Genie,Lamp,Place)).
actionagent(summon(Character,Genie,Lamp,Place), Character) :- action(summon(Character,Genie,Lamp,Place)).

action(love_spell(Genie,Target,Lover)) :- type(Genie,genie), type(Target,character), type(Lover,character), Target != Lover, Genie != Target, Genie != Lover.
actionprec(love_spell(Genie,Target,Lover), alive(Genie)) :- action(love_spell(Genie,Target,Lover)).
actionprec(love_spell(Genie,Target,Lover), -confined(Genie)) :- action(love_spell(Genie,Target,Lover)).
actionprec(love_spell(Genie,Target,Lover), alive(Target)) :- action(love_spell(Genie,Target,Lover)).
actionprec(love_spell(Genie,Target,Lover), alive(Lover)) :- action(love_spell(Genie,Target,Lover)).
actionprec(love_spell(Genie,Target,Lover), -loves(Target,Lover)) :- action(love_spell(Genie,Target,Lover)).
actionpost(love_spell(Genie,Target,Lover), loves(Target,Lover)) :- action(love_spell(Genie,Target,Lover)).
actionpost(love_spell(Genie,Target,Lover), intends(Target,married_to(Target,Lover))) :- action(love_spell(Genie,Target,Lover)).
actionagent(love_spell(Genie,Target,Lover), Genie) :- action(love_spell(Genie,Target,Lover)).

action(marry(Groom,Bride,Place)) :- type(Groom,male), type(Bride,female), type(Place,place).
actionprec(marry(Groom,Bride,Place), alive(Groom)) :- action(marry(Groom,Bride,Place)).
actionprec(marry(Groom,Bride,Place), at(Groom,Place)) :- action(marry(Groom,Bride,Place)).
actionprec(marry(Groom,Bride,Place), loves(Groom,Bride)) :- action(marry(Groom,Bride,Place)).
actionprec(marry(Groom,Bride,Place), alive(Bride)) :- action(marry(Groom,Bride,Place)).
actionprec(marry(Groom,Bride,Place), at(Bride,Place)) :- action(marry(Groom,Bride,Place)).
actionprec(marry(Groom,Bride,Place), loves(Bride,Groom)) :- action(marry(Groom,Bride,Place)).
actionpost(marry(Groom,Bride,Place), -single(Groom)) :- action(marry(Groom,Bride,Place)).
actionpost(marry(Groom,Bride,Place), married(Groom)) :- action(marry(Groom,Bride,Place)).
actionpost(marry(Groom,Bride,Place), married_to(Groom,Bride)) :- action(marry(Groom,Bride,Place)).
actionpost(marry(Groom,Bride,Place), -single(Bride)) :- action(marry(Groom,Bride,Place)).
actionpost(marry(Groom,Bride,Place), married(Bride)) :- action(marry(Groom,Bride,Place)).
actionpost(marry(Groom,Bride,Place), married_to(Bride,Groom)) :- action(marry(Groom,Bride,Place)).
actionagent(marry(Groom,Bride,Place), Groom) :- action(marry(Groom,Bride,Place)).
actionagent(marry(Groom,Bride,Place), Bride) :- action(marry(Groom,Bride,Place)).

action(fall_in_love(Male,Female,Place)) :- type(Male,male), type(Female,female), type(Place,place).
actionprec(fall_in_love(Male,Female,Place), alive(Male)) :- action(fall_in_love(Male,Female,Place)).
actionprec(fall_in_love(Male,Female,Place), single(Male)) :- action(fall_in_love(Male,Female,Place)).
actionprec(fall_in_love(Male,Female,Place), at(Male,Place)) :- action(fall_in_love(Male,Female,Place)).
actionprec(fall_in_love(Male,Female,Place), -loves(Male,Female)) :- action(fall_in_love(Male,Female,Place)).
actionprec(fall_in_love(Male,Female,Place), alive(Female)) :- action(fall_in_love(Male,Female,Place)).
actionprec(fall_in_love(Male,Female,Place), beautiful(Female)) :- action(fall_in_love(Male,Female,Place)).
actionprec(fall_in_love(Male,Female,Place), single(Female)) :- action(fall_in_love(Male,Female,Place)).
actionprec(fall_in_love(Male,Female,Place), at(Female,Place)) :- action(fall_in_love(Male,Female,Place)).
actionpost(fall_in_love(Male,Female,Place), loves(Male,Female)) :- action(fall_in_love(Male,Female,Place)).
actionpost(fall_in_love(Male,Female,Place), intends(Male,married_to(Male,Female))) :- action(fall_in_love(Male,Female,Place)).

% Due to ambiguous semantics, we will declare order actions individually in the problem file
actionprec(order(King,Knight,Place,Objective), alive(King)) :- action(order(King,Knight,Place,Objective)).
actionprec(order(King,Knight,Place,Objective), at(King,Place)) :- action(order(King,Knight,Place,Objective)).
actionprec(order(King,Knight,Place,Objective), alive(Knight)) :- action(order(King,Knight,Place,Objective)).
actionprec(order(King,Knight,Place,Objective), at(Knight,Place)) :- action(order(King,Knight,Place,Objective)).
actionprec(order(King,Knight,Place,Objective), loyal_to(Knight,King)) :- action(order(King,Knight,Place,Objective)).
actionpost(order(King,Knight,Place,Objective), intends(Knight,Objective)) :- action(order(King,Knight,Place,Objective)).
actionpost(order(King,Knight,Place,Objective), delegated(King,Objective,Knight)) :- action(order(King,Knight,Place,Objective)).
actionagent(order(King,Knight,Place,Objective),King) :- action(order(King,Knight,Place,Objective)).

% Due to ambiguous semantics, about what propositions can be delegated, we omit a general rule for this and instead
% declare individual 'command' actions in the problem file based on the compiled PDDL version of the problem.
%action(command(Character,Genie,Lamp,Objective)) :- type(Character,character), type(Genie,genie), type(Lamp,magic_lamp), positivefact(Objective), Character != Genie.
actionprec(command(Character,Genie,Lamp,Objective), intends(Character,Objective)) :- action(command(Character,Genie,Lamp,Objective)).
actionprec(command(Character,Genie,Lamp,Objective), alive(Character)) :- action(command(Character,Genie,Lamp,Objective)).
actionprec(command(Character,Genie,Lamp,Objective), has(Character,Lamp)) :- action(command(Character,Genie,Lamp,Objective)).
actionprec(command(Character,Genie,Lamp,Objective), controls(Character,Genie)) :- action(command(Character,Genie,Lamp,Objective)).
actionprec(command(Character,Genie,Lamp,Objective), alive(Genie)) :- action(command(Character,Genie,Lamp,Objective)).
actionpost(command(Character,Genie,Lamp,Objective), intends(Genie,Objective)) :- action(command(Character,Genie,Lamp,Objective)).
actionpost(command(Character,Genie,Lamp,Objective), delegated(Character,Objective,Genie)) :- action(command(Character,Genie,Lamp,Objective)).
actionagent(command(Character,Genie,Lamp,Objective),Character) :- action(command(Character,Genie,Lamp,Objective)).

action(appear_threatening(Monster,Character,Place)) :- type(Monster,monster), type(Character,character), type(Place,place), Monster != Character.
actionprec(appear_threatening(Monster,Character,Place), scary(Monster)) :- action(appear_threatening(Monster,Character,Place)).
actionprec(appear_threatening(Monster,Character,Place), at(Monster,Place)) :- action(appear_threatening(Monster,Character,Place)).
actionprec(appear_threatening(Monster,Character,Place), at(Character,Place)) :- action(appear_threatening(Monster,Character,Place)).
actionpost(appear_threatening(Monster,Character,Place), intends(Character,-alive(Monster))) :- action(appear_threatening(Monster,Character,Place)).
