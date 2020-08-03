% Enables classical planning restrictions
requiregoalachievement :- not -requiregoalachievement.


% Force goal achievement by ending plans in a dummy "finish" step with goals as preconditions
step(dummystep(finish)).
action(dummyaction(finish)).
actiontaken(dummystep(finish),dummyaction(finish)).
consecutive(executedstep(N),dummystep(finish)) :- step(executedstep(N)), N = #max { X : step(executedstep(X)) }.
consecutive(dummystep(start),dummystep(finish)) :- #count { X : step(executedstep(X)) }=0.


actionprec(dummyaction(finish),Fact) :- goal(Fact).