extends Resource
class_name Counter

@export var coin_flip_num: CoinFlip

##Search for an aspect in the game
@export_enum("Energy Attacked", "Energy Excess", "P Damage Counters",
 "Prizes Left P","Prizes Left O","Prize Difference","Constant") var for_what
##Search for the number of pokemon that meet this ask
@export var meet_ask: Ask
##What is the max value if any
@export_range(-1,100) var cap: int = 0
##For each number counted, return what?
@export_range(-10,100,10) var return_num: int = 0
