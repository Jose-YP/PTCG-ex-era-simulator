extends Resource
class_name EnMov

#@export_group("Energy Movement")
@export_enum("Basic", "Special", "Any") var energy_move_type: int = 0
@export_enum("Move", "Discard", 
"Top Deck", "Bottom Deck", "Hand Attatch") var action: int = 1
##If they targets from which meet ask, they're allowed
@export var candidates: SlotAsk
##Targets for removal
@export_flags("Attacker", "Defender", "OtherActive",
"Other Defending", "PBench", "OBench", "All") var which: int = 1
##Ammount of energy per swap. -1 means infinite.
@export var energy_ammount: int = 0
##Ammount of swaps allowed. -1 means infinite.
@export var swap_ammount: int = 1
##If any energy is currently considered
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var type: int = 2 ** 9 - 1
