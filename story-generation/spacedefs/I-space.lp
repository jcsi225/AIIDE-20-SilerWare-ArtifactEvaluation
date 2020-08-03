explanation(Step,N,Char,Act) :- actiontaken(explanationstep(Step,Char,N),Act).


% Generate unexecuted explanatory steps for each character action

% needsexplanation(Step,Char) --- Require an explanation for Char's role in Step
needsexplanation( executedstep(M), Char ) :- step(executedstep(M)), stepagent(executedstep(M),Char).
needsexplanation( explanationstep(StepOrig,CharOrig,N), CharNew ) :- step(explanationstep(StepOrig,CharOrig,N)), stepagent(explanationstep(StepOrig,CharOrig,N),CharNew), not explanationagent(explanationfor(StepOrig,CharOrig),explanationstep(StepOrig,CharOrig,N),CharNew).

% explanationagent(Exp,Step,Char) --- To contribute to explanation Exp, Step should have Char as an agent
% By default, the expected agent is the one whose action is being explained (but see delegation.lp)
explanationagent(explanationfor(StepExplained,Char),Step,Char) :- partofexplanation(explanationfor(StepExplained,Char),Step,_), {explanationagent(explanationfor(StepExplained,Char),Step,CharOther) : CharOther != Char}=0.

% shouldgenerateexplanation(Step) --- Marks the steps for which the program should actively search for explanations
% Note: To avoid blowups from many layers of nested explanation, we currently only generate explanations for executed steps.
% If a step in an explanation has an additional character, that step must immediately accomplish that character's goal.
% This appears to be sufficient for the domains from the paper (where the multiagent actions will accomplish at least
% one of the agents' goals immediately), but will not necessarily generalize.
% (Accomplished by marking multiagent steps as "needs explanation", but only generating new explanatory steps for executed steps)
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


% Require explanatory steps to be on intentional paths, as defined below
intentionalsequencemember(Exp,Step,N) :- partofexplanation(Exp,Step,N).
intentionalsequencegoal(Exp,Goal) :- explanationgoal(Exp,Goal).

% intentionalsequencemember(Seq,Step,N) --- Step is the Nth member of sequence Seq, starting from 0
% intentionalsequencegoal(Seq,Fact) --- Fact is a possible last proposition on an intentional path (for conjunctive goals, use a separate Fact for each conjunct)
intentionalsequencegoal(Seq,X) :- intentionalsequencegoal(Seq,and(X,Y)).
intentionalsequencegoal(Seq,Y) :- intentionalsequencegoal(Seq,and(X,Y)).


% The following rules test that all actions in an explanation contribute to the character goal.
% In the paper, we define this as "no strict subsequence would achieve the character goal".
% In the implementation, rather than checking strict subsequences directly (a computationally astronomical task in ASP),
% we follow the causal-chain-based definition of a "valid intentional plan" from Ware and Young's Glaive paper,
% and add additional constraints to catch a special case of superfluous actions that is not covered by that definition.
% The equivalence between our implementation and the "no strict subsequence" definition is an unproven conjecture,
% but the implementation has reliably matched the definition based on inspecting a wide variety of outputs on our domains.

% causalchain(Seq,StepBegin) --- Identify a chain by its first step
causalchain(Seq,NBegin) :- intentionalsequencemember(Seq,StepBegin,NBegin), {causalchainmember(Seq,NOther,NBegin) : NOther != NBegin}=0.
causalchainmember(Seq,NBegin,NBegin) :- causalchain(Seq,NBegin).
{ causalchainmember(Seq,NBegin,N) } :- causalchain(Seq,NBegin), intentionalsequencemember(Seq,_,N), N > NBegin.
1{ causalchainfact(Seq,NBegin,N,Fact) : stepeffect(Step,Fact) }1 :- causalchainmember(Seq,NBegin,N), intentionalsequencemember(Seq,Step,N).
% Consecutive causal chain steps must be causally-linked over the associated fact
% causallylinked(Seq,NBegin,NTail,NHead) --- The NTail and NHead steps of Seq are consecutive on the NBegin causal chain
causallylinked(Seq,NBegin,NTail,NHead) :- causalchainmember(Seq,NBegin,NTail), causalchainmember(Seq,NBegin,NHead), NTail < NHead, {causalchainmember(Seq,NBegin,NBetween) : NTail < NBetween, NBetween < NHead}=0.
:- causallylinked(Seq,NBegin,NTail,NHead), causalchainfact(Seq,NBegin,NTail,Fact), intentionalsequencemember(Seq,StepHead,NHead), not stepprec(StepHead,Fact).
% The last step must complete a goal 
:- causalchainmember(Seq,NBegin,N), N = #max{ M : causalchainmember(Seq,NBegin,M) }, causalchainfact(Seq,NBegin,N,Fact), not intentionalsequencegoal(Seq,Fact).
:- causalchainmember(Seq,NBegin,N), N = #max{ M : causalchainmember(Seq,NBegin,M) }, causalchainfact(Seq,NBegin,N,Fact), intentionalsequencegoal(Seq,Fact), intentionalsequencemember(Seq,StepUndoing,NUndoing), NUndoing > N, stepeffect(StepUndoing,-Fact).
% A chain must not contain the same fact twice
:- causalchainfact(Seq,NBegin,N1,Fact), causalchainfact(Seq,NBegin,N2,Fact), N1 != N2.
% A chain must not contain a fact and its negation
:- causalchainfact(Seq,NBegin,_,Fact), causalchainfact(Seq,NBegin,_,-Fact).

% Prevent subsequences that have no useful net effect
:- intentionalsequencemember(Exp,StepIntervalStart,NIntervalStart), intentionalsequencemember(Exp,StepPostInterval,NPostInterval), NIntervalStart < NPostInterval,
	{ causalchainfact(Exp,NB,NTail,Fact) : intentionalsequencemember(Exp,StepHead,NHead), causallylinked(Exp,NB,NTail,NHead), 
		NTail >= NIntervalStart, NTail < NPostInterval, NHead >= NPostInterval,	not holdsbefore(StepIntervalStart,Fact) }=0,
	{ causalchainfact(Exp,NB,NTail,Fact) : intentionalsequencegoal(Exp,Fact), 
		NTail >= NIntervalStart, NTail < NPostInterval,	not holdsbefore(StepIntervalStart,Fact) }=0.
:- intentionalsequencemember(Exp,Step,N), { intentionalsequencegoal(Exp,Fact) : not holdsbefore(Step,Fact) }=0.
