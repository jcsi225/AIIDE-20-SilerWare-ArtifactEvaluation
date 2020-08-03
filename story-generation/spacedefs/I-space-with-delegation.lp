% This version handles features present only in Aladdin (i.e., delegation),
% but cannot handle certain features absent from Aladdin (e.g., conjunctive goals)

explanation(Step,N,Char,Act) :- actiontaken(explanationstep(Step,Char,N),Act).


% Generate unexecuted explanatory steps for each character action

% needsexplanation(Step,Char) --- Require an explanation for Char's role in Step
needsexplanation( executedstep(M), Char ) :- step(executedstep(M)), stepagent(executedstep(M),Char).
needsexplanation( explanationstep(StepOrig,CharOrig,N), CharNew ) :- step(explanationstep(StepOrig,CharOrig,N)), stepagent(explanationstep(StepOrig,CharOrig,N),CharNew), not explanationagent(explanationfor(StepOrig,CharOrig),explanationstep(StepOrig,CharOrig,N),CharNew).

% explanationagent(Exp,Step,Char) --- To contribute to explanation Exp, Step should have Char as an agent
% By default, the expected agent is the one whose action is being explained (delegation changes this)
explanationagent(explanationfor(StepExplained,Char),Step,Char) :- partofexplanation(explanationfor(StepExplained,Char),Step,_), {explanationagent(explanationfor(StepExplained,Char),Step,CharOther) : CharOther != Char}=0.

% shouldgenerateexplanation(Step) --- Marks the steps for which the program should actively search for explanations
% Note: To avoid blowups from many layers of nested explanation, we currently only generate explanations for executed steps.
% If a step in an explanation has an additional character, that step must immediately accomplish that character's goal.
% (Accomplished by marking multiagent steps as "needs explanation", but only generating new explanatory steps for executed steps)
% This is sufficient for the domains from the paper (where the multiagent actions will accomplish at least
% one of the agents' goals immediately), but will not necessarily generalize.
shouldgenerateexplanation( executedstep(N) )  :- needsexplanation( executedstep(N), _ ).

% step( explanationstep(Step,Char,N) ) --- The Nth in a sequence of steps generated to explain Char's role in Step
{ step( explanationstep(Step,Char,0) ) }  :- needsexplanation(Step,Char), shouldgenerateexplanation(Step).
{ step( explanationstep(StepExplained,Char,N) ) } :- step(explanationstep(StepExplained,Char,N-1)), N < maxexplanationdepth.
1{ actiontaken(explanationstep(StepExplained,CharExplained,N),Act) : action(Act), actionagent(Act,Char), explanationagent(explanationfor(StepExplained,CharExplained),explanationstep(StepExplained,CharExplained,N),Char) }1 :- step(explanationstep(StepExplained,CharExplained,N)).


% partofexplanation(explanationfor(StepExplained,Char),StepExplaining,N) --- StepExplaining is the Nth step of the explanation for StepExplained, with StepExplained itself as the 0th step
% Convenience predicate so we can refer to the executed and unexecuted parts of the sequence in the same way without writing two separate rules
partofexplanation(explanationfor(StepExplained,Char),StepExplained,0) :- needsexplanation(StepExplained,Char).
partofexplanation(explanationfor(Step,Char),explanationstep(Step,Char,N),N+1) :- step(explanationstep(Step,Char,N)).
consecutive(StepEx1,StepEx2) :- partofexplanation(Exp,StepEx1,N), partofexplanation(Exp,StepEx2,N+1). 

% explanationgoal(Exp,Goal) --- The explanation Exp shows how its character could accomplish character goal Goal
1{ explanationgoal(explanationfor(Step,Char),Goal) : holdsbefore(Step,intends(Char,Goal)) }1 :- needsexplanation(Step,Char).
explanationgoal(Exp,Goal) :- partofexplanation(Exp,StepExplaining,_), explanationgoal(Exp,Goal).
% Character goal must continue to hold throughout the explanation
:- explanationgoal(explanationfor(Step,Char),Goal), stepeffect(Step,-intends(Char,Goal)).
% Character goal must be reached at the end of the explanation
:- explanationgoal(Exp,Goal), partofexplanation(Exp,StepLast,N), N = #max {M : partofexplanation(Exp,_,M)}, not stepeffect(StepLast,Goal).


% Identify causal links that could contribute to the character goal
% causallylinkedtoexplanationgoal(Exp,Step) --- Step in explanation Exp is on a causal path to the character goal
% explanatorycausallink(StepFirst,StepLast,Fact) --- A member of that causal path over proposition Fact
causallylinkedtoexplanationgoal(Exp,Step) :- explanationgoal(Exp,Goal), partofexplanation(Exp,Step,_), stepeffect(Step,Goal).
explanatorycausallink(StepFirst,StepLast,Fact) :- stepeffect(StepFirst,Fact), stepprec(StepLast,Fact), partofexplanation(Exp,StepFirst,NFirst), partofexplanation(Exp,StepLast,NLast), NFirst < NLast, causallylinkedtoexplanationgoal(Exp,StepLast), {partofexplanation(Exp,StepBetween,NBetween) : NFirst < NBetween, NBetween < NLast, stepeffect(StepBetween,-Fact)}=0.
causallylinkedtoexplanationgoal(Exp,Step) :- partofexplanation(Exp,Step,_), explanatorycausallink(Step,StepOther,_).


% The following rules test that all actions in an explanation contribute to the character goal.
% In the paper, we define this as "no strict subsequence would achieve the character goal".
% In the implementation, rather than checking strict subsequences directly (a computationally astronomical task in ASP),
% we follow the causal-chain-based definition of a "valid intentional plan" from Ware and Young's Glaive paper,
% and add additional constraints to catch a special case of superfluous actions that is not covered by that definition.
% The equivalence between our implementation and the "no strict subsequence" definition is an unproven conjecture,
% but the implementation has reliably matched the definition based on inspecting a wide variety of outputs on our domains.

% All explained/explanatory steps should be on a causal path to the character goal
%1{ oncausalchain(Exp,StepBegin,Step,G) : partofexplanation(Exp,StepBegin) } :- explanationgoal(Exp,Goal), partofexplanation(Exp,Step,_), stepeffect(Step,Goal).
onintentionalpath(Exp,Step,Goal) :- explanationgoal(Exp,Goal), partofexplanation(Exp,Step,_), stepeffect(Step,Goal).
onintentionalpath(Exp,StepNewHead,Fact) :- partofexplanation(Exp,StepNewHead,_), explanatorycausallink(StepNewHead,StepOldHead,Fact), onintentionalpath(Exp,StepOldHead,_), {onintentionalpath(Exp,StepOther,Fact) : StepOther != StepNewHead}=0,  {onintentionalpath(Exp,StepOther,-Fact)}=0.
:- partofexplanation(Exp,Step,_), {onintentionalpath(Exp,Step,_)}=0.


% Prevent subsequences that have no useful net effect
:- partofexplanation(Exp,StepIntervalStart,NIntervalStart), partofexplanation(Exp,StepPostInterval,NPostInterval), NIntervalStart < NPostInterval,
	{ explanatorycausallink(StepTail,StepHead,Fact) : partofexplanation(Exp,StepTail,NTail), partofexplanation(Exp,StepHead,NHead),
		NTail >= NIntervalStart, NTail < NPostInterval, NHead >= NPostInterval,	not holdsbefore(StepIntervalStart,Fact) }=0.
:- partofexplanation(Exp,Step,_), explanationgoal(Exp,Goal), stepeffect(Step,-Goal).




% Delegation semantics

positivefact(delegated(CharOrig,Goal,CharDelegated)) :- actionpost(_,delegated(CharOrig,Goal,CharDelegated)).

% partofdelegationsubsequence(Exp,Char,Goal,N) --- The Nth step of explanation N is part of Char carrying out a delegated Goal (starts upon delegation, ends when the goal is accomplished)
% startofdelegationsubsequence(Exp,Char,Goal,N) --- The first of those steps
startofdelegationsubsequence(Exp,CharDelegated,Goal,N) :- partofexplanation(Exp,Step,N), partofexplanation(Exp,StepPrev,N-1), explanationagent(Exp,StepPrev,CharPrev), stepeffect(StepPrev,delegated(CharPrev,Goal,CharDelegated)), not holdsbefore(Step,Goal).
partofdelegationsubsequence(Exp,CharDelegated,Goal,N) :- startofdelegationsubsequence(Exp,CharDelegated,Goal,N).
partofdelegationsubsequence(Exp,CharDelegated,Goal,N) :- partofexplanation(Exp,Step,N), partofdelegationsubsequence(Exp,CharDelegated,Goal,N-1), not holdsbefore(Step,Goal).

explanationagent(Exp,Step,Char) :- partofexplanation(Exp,Step,N), partofdelegationsubsequence(Exp,Char,Goal,N), startofdelegationsubsequence(Exp,Char,Goal,NStart), NStart = #max { M : startofdelegationsubsequence(Exp,C,G,M), partofdelegationsubsequence(Exp,C,G,N) }.

% Let delegation count as a causal link
explanatorycausallink(StepFirst,StepLast,delegated(Char1,Goal,Char2)) :- partofexplanation(Exp,StepFirst,NFirst), partofexplanation(Exp,StepLast,NFirst+1), stepagent(StepFirst,Char1), stepagent(StepLast,Char2), stepeffect(StepFirst,delegated(Char1,Goal,Char2)).


