extends Resource
class_name Search

@export_enum("Player", "Opponent") var side
@export_enum("Discard", "Deck") var where
@export var how_many: int = 1
@export var of_this: Array[Identifier]
@export var and_then: Placement
@export var reveal: bool = true
