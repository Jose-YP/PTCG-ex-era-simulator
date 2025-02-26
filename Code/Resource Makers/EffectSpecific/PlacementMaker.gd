extends Resource
class_name Placement

@export_enum("Hand", "Top Deck", "Bottom Deck", "Deck", "Self",
"Active Mon", "Bench Mon", "Any Mon") var where: int = 0

@export var shuffle: bool = true
##Apply the effects of evolution on this card,
##otherwise it'll just swap current card
@export var evolve: bool = false
