extends Resource
class_name Ask

@export_group("To Activate")
##If this ask isn't met, look for the next ask
@export var or_ask: Ask
##Which side to pay attention to
@export_enum("None", "Player", "Opponent", "Both") var target: int = 0
##-10 means don't look at this var, 0 means must be undamaged, the rest mean x or more
@export_range(-10,200,10) var damage_taken: int = -10
##-1 means don't look at this var, 0 means must have no energy, the rest mean x or more
@export var energy_attatched: int = -1
@export var knocked_out: bool = false
@export_flags("Poison", "Burn", "Paralysis", "Asleep", "Confusion") var condition: int = 0
##Self means the attacking/defending pokemon, Active is for doubles
@export_flags("Bench", "Active", "Self", "Discard", "Hand") var location: int = 0 

@export_subgroup("Class")
@export_flags("Basic", "Stage 1", "Stage 2") var stage: int = 7
##Only including specified or excluding specified
@export var inclusive: bool = true
@export_flags("Baby", "ex", "Delta", "Star",
 "Magma", "Aqua", "Rocket", "Dark") var pokemon_class: int = 0
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
