extends Resource
class_name Search

@export_enum("Player", "Opponent") var side
@export_enum("Discard", "Deck") var where
##How many cards in the desirec section can you check.
##-1 means all cards
@export_range(-1,80, 1) var portion: int = -1
##How many cards can the user pick 
@export var how_many: int = 1
##For each item in identifier, search how_many
@export var of_this: Array[Identifier]
@export var and_then: Placement
@export var reveal: bool = true
