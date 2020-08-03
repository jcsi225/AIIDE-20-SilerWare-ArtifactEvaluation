% Requires Asprin

% Extend plans as long as we are within the step limit and an explanable action is possible
% This does not appear to be possible purely with ASP rules, so we implement it as a preference
%	for action sequences that are supersets of others
#preference(maximalplans,superset){ actiontaken(executedstep(N),Act) }.

#optimize(maximalplans).