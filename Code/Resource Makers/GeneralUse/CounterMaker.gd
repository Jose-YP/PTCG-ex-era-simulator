extends Resource
class_name Counter

##What does the count affect. Damage count return a multiple of 10
##Number count returns just the number
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
@export_flags("Player Bench", "Opponent Bench", "Player Active",
 "Opponent Active", "Attacker", "Defender") var mon_count: int = 0
##Search for an aspect in the game
@export_enum("Energy Attatched", "Energy Excess", "P Damage Counters",
 "Prizes Left P","Prizes Left O","Prize Difference","Constant") var for_what
##Search for the number of pokemon that meet this ask
@export var meet_ask: Ask
##What is the max value if any
@export_group("Returns")
@export_range(-1,100) var cap: int = 0
##For each number counted, return what?
@export_range(-10,100,10) var return_num: int = 0

func return_count():
	
	pass
