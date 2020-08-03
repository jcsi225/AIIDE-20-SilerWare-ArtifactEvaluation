Contents of this folder:

asprin-maximality.lp --- Preference file requiring Asprin (without this, the other files are compatible with base Clingo).
                         Used to filter answer sets by maximality in terms of step inclusion; i.e., no additional
						 steps could be added to the story and still meet the desired solution definition.
A-space.lp --- Rules for a solution set where the author goal must be (provably, within a limited number of steps) still 
               reachable from the end state of the story. Corresponds to the A / "drama managed" solution set in the paper.
I-space.lp --- Rules for a solution set where each character action must be (provably, within a limited number of steps)
               a nonsuperfluous step on a possible plan to achieve one of that character's goals. Corresponds to the I /
			   "intentional" solution set in the paper.
I-space-with-delegation.lp --- Modifications to work specifically with the Aladdin domain, which has a special feature
                               where some actions allow characters to assign goals to each other.
L-space.lp --- Basic rules for a legal sequence of actions. Corresponds to the L / "legal" solution set in the paper.
               When producing A/I/S plans, the L-space rules must be included as well.
S-space.lp --- Rules for a solution set where the author goal is achieved at the end. Corresponds to the S / "structured"
               solution set in the paper, i.e., classical plans.