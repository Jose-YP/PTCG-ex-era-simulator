##This resource is responcible for telling the computer what should be counted[br]
##It will run a vartiety of functions depending on [member for_what][br]
##This is done to return either count of the provided thing for effects or damage
extends Resource
class_name Counter

##What does the count affect. Damage count return [member return_num] * 10.[br]
##Number count returns just the [member return_num][br]
##Eq, NEq, > & < are all for booleans
@export_enum("Damage Count", "Number Count",
 "Equal", "Unequal", "Greater", "Less") var count_for: int = 0 
##Self is for current attacker/defender
@export_enum("Including self", "Only like mons",
 "Excluding Self", "Everyone else", "Only Self") var filter: int = 4
##Which mons to count
@export_group("Count Methods")
@export var coin_flip_num: CoinFlip
##Ways to count current mons in play, might not be used in favor of meet_ask
@export var side: Constants.SIDES = Constants.SIDES.ATTACKING
@export var slot: Constants.SLOTS = Constants.SLOTS.TARGET

##Search for an aspect in the game
@export_enum("Constant", "Energy Attatched", "Energy Excess", "Damage Counters",
 "Prizes Left","Prize Difference","Hand","Hand Difference","Discard",
"Discard Diff", "Pokemon in Play") var for_what: int = 0

##Search for the number of pokemon that meet this ask
@export var meet_ask: SlotAsk
##What is the max value if any
@export_group("Returns")
##-1 mean there is no cap, otherwise, cap determines what the max value can be 
@export_range(-1,100) var cap: int = -1
##For each number counted, return what? This number will be multiplied by 10 with Damage Count
@export_range(-1,10,1) var return_num: int = 0

var functions: Array[Callable] = [energy_count, energy_excess, damage_count, prize_count,
prize_difference, hand_count, hand_difference, discard_count, discard_difference, pokemon_count]

func return_count():
	pass

func energy_count():
	pass

func energy_excess():
	pass

func damage_count():
	pass

func prize_count():
	pass

func prize_difference():
	pass

func hand_count():
	pass

func hand_difference():
	pass

func discard_count():
	pass

func discard_difference():
	pass

func pokemon_count():
	pass
