type(saloon,place).
type(ranch,place).
type(generalstore,place).
type(hank,person).
type(timmy,person).
type(will,person).
type(carl,person).
type(antivenom,item).

init(alive(hank)).
init(free(hank)).
init(at(hank,ranch)).
init(loves(hank,timmy)).
init(alive(timmy)).
init(free(timmy)).
init(at(timmy,ranch)).
init(loves(timmy,hank)).
init(alive(will)).
init(free(will)).
init(at(will,saloon)).
init(alive(carl)).
init(free(carl)).
init(at(carl,generalstore)).
init(has(carl,antivenom)).
init(cures(antivenom,snakebite)).

goal(-alive(timmy)).
goal(-free(hank)).