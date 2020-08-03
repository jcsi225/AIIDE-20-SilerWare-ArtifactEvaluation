usage: generate.py [-h] [-a] [-i] [-s] [--first] [--hide-steps]
                   [--show-a-proofs] [--show-i-proofs]
                   {aladdin,raiders,storygraphs,villains,western} length

positional arguments:
  {aladdin,raiders,storygraphs,villains,western}
                        which story generation domain to use
  length                maximum number of steps

optional arguments:
  -h, --help            show this help message and exit
  -a                    include solution set A restrictions; author goal must
                        not be made impossible
  -i                    include solution set I restrictions; character actions
                        must be explainable
  -s                    include solution set S restrictions; author goal must
                        be achieved
  --first               find only one story (default: find all)
  --hide-steps          hide the executed steps (default: show)
  --show-a-proofs       show the author-goal reachability steps for A
                        (default: hide)
  --show-i-proofs       show the explanatory steps for I (default: hide)