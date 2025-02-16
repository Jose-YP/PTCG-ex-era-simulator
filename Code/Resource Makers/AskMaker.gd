extends Resource
class_name Ask

@export_group("To Activate")
##Which side to pay attention to
@export_enum("None", "Player", "Opponent") var target: int = 0
##10 means don't look at this var, 0 means must be undamaged, the rest mean x or more
@export_range(-10,200,10) var damage_taken: int = -1
@export var knocked_out: bool = false
@export_flags("Poison", "Burn", "Paralysis", "Asleep", "Confusion") var condition: int = 0
##Self means the active pokemon using the effect, Active is for doubles
@export_flags("Bench", "Active", "Self", "Discard", "Hand") var location: int = 0 
@export_subgroup("Class")
##Only including specified or excluding specified
@export var inclusive: bool = true
@export_flags("Baby", "ex", "Delta", "Star",
 "Magma", "Aqua", "Rocket") var pokemon_class: int = 0
@export_subgroup("Bench")
##Look for 
@export_range(-1,5) var bench_size: int = -1
@export_subgroup("Type")
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var type: int = 1023
@export var type_size: int = 1

@export_group("Before Activating")
@export_multiline var ask_string: String 
@export var coin_flip: CoinFlip
##Give a prompt asking to activate the effect
@export var formal_ask: bool = false
@export_enum("None", "Player", "Opponent") var choose: int = 0
@export_flags("Bench", "Active", "Self", 
"Discard", "Hand") var choose_location: int = 0
