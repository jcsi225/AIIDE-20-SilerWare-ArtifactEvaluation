% Prevent character actions that would put the world in a state where the author goal is unreachable by a classical plan


dmproof(N,Act) :- actiontaken(dmproofstep(N),Act).

{ step(dmproofstep(0)) } :- maxdmproofsteps > 0.
{ step(dmproofstep(N)) } :- step(dmproofstep(N-1)), N < maxdmproofsteps.
consecutive(executedstep(N),dmproofstep(0)) :- step(dmproofstep(0)), N = #max { M : step(executedstep(M)) }.
consecutive(dmproofstep(N),dmproofstep(N+1)) :- step(dmproofstep(N)), step(dmproofstep(N+1)).

shouldgenerateaction( dmproofstep(N) ) :- step(dmproofstep(N)).

% Verify that the author goal is still possible after the plan, even if not achieved by the plan
step(dummystep(dmprooffinish)).
action(dummyaction(dmprooffinish)).
actiontaken(dummystep(dmprooffinish),dummyaction(dmprooffinish)).
consecutive(dmproofstep(N),dummystep(dmprooffinish)) :- step(dmproofstep(N)), N = #max { X : step(dmproofstep(X)) }.
consecutive(executedstep(N),dummystep(dmprooffinish)) :- #count { X : step(dmproofstep(X)) }=0, N = #max { M : step(executedstep(M)) }.


actionprec(dummyaction(dmprooffinish),Fact) :- goal(Fact).


:- step(dmproofstep(N)), {goal(Goal) : not holdsbefore(dmproofstep(N))}=0.