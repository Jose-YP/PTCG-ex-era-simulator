extends Resource
class_name Counter

@export var coin_flip_num: CoinFlip

@export_enum("Energy Attacked", "Energy Excess", "P Damage Counters",
 "Constant") var for_what
@export var cap: int = 0
@export var return_num: int = 0
