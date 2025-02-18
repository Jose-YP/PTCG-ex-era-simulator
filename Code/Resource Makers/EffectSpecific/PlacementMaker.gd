extends Resource
class_name Placement

@export_enum("Hand", "Top Deck", "Bottom Deck", "Deck",
"Active Mon", "Bench Mon") var where

@export var shuffle: bool = true
@export var evolve: bool = false
