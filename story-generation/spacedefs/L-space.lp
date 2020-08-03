% Set const plan length limit 'maxsteps' in settings.lp
executed(N,Act) :- actiontaken(executedstep(N),Act).


% Generate plan steps with actions for each

% step(Step) --- Unique identifier for a step
% step(executedstep(N)) --- Real steps in the plan, executed in order of N
{ step(executedstep(0)) } :- maxsteps > 0.
{ step(executedstep(N)) } :- step(executedstep(N-1)), N < maxsteps.

% shouldgenerateaction(Step) --- Choose an action for Step 
shouldgenerateaction( executedstep(N) ) :- step(executedstep(N)).

% actiontaken(Step,Act) --- Action Act chosen for step Step
%	Step --- Step identifier
1{ actiontaken(Step,Act) : action(Act) }1 :- shouldgenerateaction(Step).


% Test that the action sequence is valid with respect to action preconditions

% consecutive(Step1,Step2) --- The first step occurs directly before the second (for executed steps, just use consecutive IDs)
consecutive(executedstep(N),executedstep(N+1)) :- step(executedstep(N)), step(executedstep(N+1)).


% Step effects

% steppost(Step,Fact) --- Fact is an effect of the action taken at Step or one of the axioms induced
% actionpost(Act,Fact) --- Action Act makes Fact true
% axiompost(Ax,Fact) --- Axiom Ax makes Fact true
steppost(Step,Fact) :- fact(Fact), step(Step), action(Act), actiontaken(Step,Act), actionpost(Act,Fact), not steppost(Step,-Fact).
steppost(Step,Fact) :- fact(Fact), step(Step), axiom(Ax), axiomtriggered(Step,Ax), axiompost(Ax,Fact).


% Axiom occurrence

% axiomtriggered(Step,Ax) --- Axiom Ax is applied after the action of Step
% axiomprec(Ax,Fact) --- Axiom Ax has Fact as part of its context
axiomtriggered(Step,Ax) :- axiom(Ax), step(Step), actiontaken(Step,Act), { axiomprec(Ax,Fact) : not holdsbefore(Step,Fact), not actionpost(Act,Fact), not steppost(Step,Fact) }=0,
	{ axiomprec(Ax,Fact) : actionpost(Act,-Fact) }=0.

	
% Apply initial state through a dummy step (so axioms apply, etc.)

step(dummystep(start)).
action(dummyaction(start)).
actiontaken(dummystep(start),dummyaction(start)).
actionpost(dummyaction(start),Fact) :- init(Fact).
init(-Fact) :- positivefact(Fact), not init(Fact).
consecutive(dummystep(start),executedstep(0)) :- step(executedstep(0)).

:- actiontaken(Step,dummyaction(Dummy)), Step != dummystep(Dummy).


% Fact persistence/change

% holdsbefore(Step,Fact) --- Fact is true at the time of Step, before the next action is taken (used to check Step precondition fulfillment)
% fact(Fact) --- Atomic proposition
% init(Fact) --- Facts that are true before any actions are taken
holdsbefore(Step,Fact) :- fact(Fact), step(Step), consecutive(StepBefore,Step), holdsbefore(StepBefore,Fact), not steppost(StepBefore,-Fact).
holdsbefore(Step,Fact) :- fact(Fact), step(Step), consecutive(StepBefore,Step), steppost(StepBefore,Fact).


% Action precondition enforcement

% legal(Step,Act) :- Action Act has its preconditions met at Step
% actionprec(Act,Fact) --- Action Act is only legal if Fact true
legal(Step,Act) :- action(Act), step(Step), {actionprec(Act,Fact) : not holdsbefore(Step,Fact)}=0.
:- actiontaken(Step,Act), not legal(Step,Act).


% Domain fluents should be declared in their positive forms in the domain file

fact(Fact;-Fact) :- positivefact(Fact).


% Make sure "intends" (character goal) is treated as a fact as well

positivefact(intends(Char,Goal)) :- init(intends(Char,Goal)).
positivefact(intends(Char,Goal)) :- actionpost(_,intends(Char,Goal)).
positivefact(intends(Char,Goal)) :- actionconditionalpost(_,_,intends(Char,Goal)).
positivefact(intends(Char,Goal)) :- axiompost(_,intends(Char,Goal)).


% Convenience predicates

% stepeffect(Step,Fact) --- Retroactive "actual" effects of a step, excluding what was already true
stepeffect(Step,Fact) :- steppost(Step,Fact), not holdsbefore(Step,Fact).
% stepprec(Step,Fact) --- Retroactive preconditions of a step, based on the action taken
stepprec(Step,Fact) :- fact(Fact), step(Step), action(Act), actiontaken(Step,Act), actionprec(Act,Fact). 
% actionagent(Act,Char) --- Char is a consenting character for Step (define in the planning domain)
% stepagent(Step,Char) --- Action chosen at Step has Char as actor
stepagent(Step,Char) :- actiontaken(Step,Act), actionagent(Act,Char).


% Enhanced logic features

% Conjunctive goals
positivefact(and(X,Y)) :- goal(and(X,Y)).
positivefact(and(X,Y)) :- positivefact(intends(_,and(X,Y))).
positivefact(X) :- positivefact(and(X,_)).
positivefact(Y) :- positivefact(and(_,Y)).
axiom(conjunctionaxiom(X,Y)) :- positivefact(and(X,Y)).
axiomprec(conjunctionaxiom(X,Y),X) :- axiom(conjunctionaxiom(X,Y)).
axiomprec(conjunctionaxiom(X,Y),Y) :- axiom(conjunctionaxiom(X,Y)).
axiomprec(conjunctionaxiom(X,Y),-and(X,Y)) :- axiom(conjunctionaxiom(X,Y)).
axiompost(conjunctionaxiom(X,Y),and(X,Y)) :- axiom(conjunctionaxiom(X,Y)).
axiom(conjunctionnegation1(X,Y)) :- positivefact(and(X,Y)).
axiomprec(conjunctionnegation1(X,Y),-X) :- axiom(conjunctionnegation1(X,Y)).
axiomprec(conjunctionnegation1(X,Y),and(X,Y)) :- axiom(conjunctionnegation1(X,Y)).
axiompost(conjunctionnegation1(X,Y),-and(X,Y)) :- axiom(conjunctionnegation1(X,Y)).
axiom(conjunctionnegation2(X,Y)) :- positivefact(and(X,Y)).
axiomprec(conjunctionnegation2(X,Y),-Y) :- axiom(conjunctionnegation2(X,Y)).
axiompost(conjunctionnegation2(X,Y),-and(X,Y)) :- axiom(conjunctionnegation2(X,Y)).

% Disjunctive goals
positivefact(or(X,Y)) :- goal(or(X,Y)).
positivefact(or(X,Y)) :- positivefact(intends(_,or(X,Y))).
positivefact(or(X,Y)) :- actionprec(_,or(X,Y)).
positivefact(X) :- positivefact(or(X,_)).
positivefact(Y) :- positivefact(or(_,Y)).
axiom(disjunctionaxiom1(X,Y)) :- positivefact(or(X,Y)).
axiomprec(disjunctionaxiom1(X,Y),X) :- axiom(disjunctionaxiom1(X,Y)).
axiomprec(disjunctionaxiom1(X,Y),-or(X,Y)) :- axiom(disjunctionaxiom1(X,Y)).
axiompost(disjunctionaxiom1(X,Y),or(X,Y)) :- axiom(disjunctionaxiom1(X,Y)).
axiom(disjunctionaxiom2(X,Y)) :- positivefact(or(X,Y)).
axiomprec(disjunctionaxiom2(X,Y),Y) :- axiom(disjunctionaxiom2(X,Y)).
axiomprec(disjunctionaxiom2(X,Y),-or(X,Y)) :- axiom(disjunctionaxiom2(X,Y)).
axiompost(disjunctionaxiom2(X,Y),or(X,Y)) :- axiom(disjunctionaxiom2(X,Y)).
axiom(disjunctionnegation(X,Y)) :- positivefact(or(X,Y)).
axiomprec(disjunctionnegation(X,Y),-X) :- axiom(disjunctionnegation(X,Y)).
axiomprec(disjunctionnegation(X,Y),-Y) :- axiom(disjunctionnegation(X,Y)).
axiomprec(disjunctionnegation(X,Y),or(X,Y)) :- axiom(disjunctionnegation(X,Y)).
axiompost(disjunctionnegation(X,Y),-or(X,Y)) :- axiom(disjunctionnegation(X,Y)).

% Conditional effects
% actionconditionalpost(Act,FactCond,FactEff) --- When FactCond holds, action Act has additional effect FactEff
steppost(Step,FactEff) :- fact(FactEff), step(Step), action(Act), actiontaken(Step,Act), holdsbefore(Step,FactCond), actionconditionalpost(Act,FactCond,FactEff), not steppost(Step,-FactEff).
%todo: handle conjunctions more robustly
positivefact(and(X,Y)) :- actionconditionalpost(_,and(X,Y),_).



% End a sequence if all author goals have been reached
:- step(executedstep(N)), {goal(Fact) : not holdsbefore(executedstep(N),Fact)}=0.