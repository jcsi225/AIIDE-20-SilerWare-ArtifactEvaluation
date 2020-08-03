import argparse
import os
import subprocess
import tempfile

domains = ['aladdin', 'raiders', 'storygraphs', 'villains', 'western']

parser = argparse.ArgumentParser()
parser.add_argument('domain', choices=domains,
                    help="which story generation domain to use")
parser.add_argument('length', action='store', type=int, nargs=1,
                    help="maximum number of steps")
parser.add_argument('-a', action='store_true',
                    help="include solution set A restrictions; author goal must not be made impossible")
parser.add_argument('-i', action='store_true',
                    help="include solution set I restrictions; character actions must be explainable")
parser.add_argument('-s', action='store_true',
                    help="include solution set S restrictions; author goal must be achieved")
            
parser.add_argument('--first', action='store_true',
                    help="find only one story (default: find all)")
parser.add_argument('--hide-steps', action='store_true',
                    help="hide the executed steps (default: show)")
parser.add_argument('--show-a-proofs', action='store_true',
                    help="show the author-goal reachability steps for A (default: hide)")
parser.add_argument('--show-i-proofs', action='store_true',
                    help="show the explanatory steps for I (default: hide)")

args = parser.parse_args()
aProofsShown = args.show_a_proofs and args.a
iProofsShown = args.show_i_proofs and args.i

tmp = tempfile.NamedTemporaryFile(suffix='.lp', mode='w', delete=False)

# Build a call to Asprin with the relevant domain files and solution-set definitions
aspArgs =  ["asprin",
            "--project",
            "domains/{}-domain.lp".format(args.domain),
            "domains/{}-problem.lp".format(args.domain),
            "spacedefs/asprin-maximality.lp",
            "spacedefs/L-space.lp",
            tmp.name]
if args.a:
    aspArgs.append("spacedefs/A-space.lp")
if args.i:
    if args.domain == "aladdin":
        aspArgs.append("spacedefs/I-space-with-delegation.lp")
    else:
        aspArgs.append("spacedefs/I-space.lp")
if args.s:
    aspArgs.append("spacedefs/S-space.lp")
if not args.first:
    aspArgs.append("-n 0")
if args.hide_steps and (not aProofsShown) and (not iProofsShown):
    aspArgs.append("--quiet=2")

# In a temporary Clingo file, specify solution length and which atoms to show
settings = ["#const maxsteps = {}.".format(args.length[0])]
if not args.hide_steps:
    settings.append("#show executed/2.")
if aProofsShown:
    settings.append("#show dmproof/2.")
if args.a:
    settings.append("#const maxdmproofsteps = {}.".format(int(args.length[0])-1))
if iProofsShown:
    settings.append("#show explanation/4.")
if args.i:
    settings.append("#const maxexplanationdepth = {}.".format(int(args.length[0])-1))
with tmp as tmpFile:
    print('\n'.join(settings), file=tmpFile)

# Run Asprin to generate the solutions
print(" ".join(aspArgs))
subprocess.call(aspArgs)
tmp.close()
os.unlink(tmp.name)




