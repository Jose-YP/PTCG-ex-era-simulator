extends Resource
class_name Ask

@export_group("To Activate")
@export_enum("None", "Player", "Opponent") var target: int = 0
@export_flags("Bench", "Active", "Self", "Discard", "Hand") var location: int = 0

@export_subgroup("Bench")
@export_range(-1,5) var bench_size: int = -1

@export_subgroup("Type")
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var type: int = 1023
@export var type_size: int = 1

@export_group("Before Activating")
@export var coin_flip: CoinFlip
@export_enum("None", "Player", "Opponent") var choose: int = 0
@export_flags("Bench", "Active", "Self", 
"Discard", "Hand") var choose_location: int = 0
