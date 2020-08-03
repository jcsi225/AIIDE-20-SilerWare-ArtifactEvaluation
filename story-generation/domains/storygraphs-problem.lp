type(player,humanoid).
type(bandit,humanoid).
type(guard,guard).
type(merchant,merchant).
type(crossroads,location).
type(camp,location).
type(market,location).
type(home,location).
type(medicine,item).
type(player_coin,money).
type(bandit_coin,money).
type(bandit_sword,weapon).
type(guard_sword,weapon).
type(merchant_sword,weapon).
init(path(home,crossroads)).
init(path(crossroads,home)).
init(path(camp,crossroads)).
init(path(crossroads,camp)).
init(path(market,crossroads)).
init(path(crossroads,market)).
init(alive(player)).
init(knows_location(player,home)).
init(knows_location(player,crossroads)).
init(knows_location(player,camp)).
init(knows_location(player,market)).
init(at(player,home)).
init(has(player,player_coin)).
init(alive(bandit)).
init(knows_location(bandit,camp)).
init(knows_location(bandit,crossroads)).
init(knows_location(bandit,home)).
init(knows_location(bandit,market)).
init(at(bandit,camp)).
init(has(bandit,bandit_sword)).
init(owns(bandit,bandit_sword)).
init(at(bandit_coin,camp)).
init(owns(bandit,bandit_coin)).
init(criminal(bandit)).
init(alive(guard)).
init(knows_location(guard,camp)).
init(knows_location(guard,crossroads)).
init(knows_location(guard,home)).
init(knows_location(guard,market)).
init(at(guard,market)).
init(has(guard,guard_sword)).
init(alive(merchant)).
init(knows_location(merchant,camp)).
init(knows_location(merchant,crossroads)).
init(knows_location(merchant,home)).
init(knows_location(merchant,market)).
init(at(merchant,market)).
init(has(merchant,merchant_sword)).
init(has(merchant,medicine)).

init(intends(player,and(at(player,home),has(player,medicine)))).

init(intends(merchant,and(has(merchant,player_coin),-criminal(merchant)))).
init(intends(merchant,and(has(merchant,bandit_coin),-criminal(merchant)))).
init(intends(merchant,at(merchant,market))).

% Other guard goals are generated from axioms
init(intends(guard,at(guard,market))).

init(intends(bandit,or(has(bandit,bandit_coin),at(bandit_coin,camp)))).
init(intends(bandit,has(bandit,player_coin))).
init(intends(bandit,has(bandit,medicine))).
init(intends(bandit,at(bandit,camp))).

goal(and( at(player,home), has(player,medicine) )).