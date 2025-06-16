extends Resource
class_name EnMov

#@export_group("Energy Movement")
@export_enum("Basic", "Special", "Any") var energy_move_type: int = 0
@export_enum("Move", "Discard", "Top Deck", "Bottom Deck",
 "Hand Attatch", "Hand DIscard") var action: int = 1
##If the chooser is [enum Constants.SIDES.NONE], then default to [member side]
@export var chooser: Constants.SIDES = Constants.SIDES.NONE
##If they targets from which meet ask, they're allowed
@export var candidates: SlotAsk
##Targets for removal
@export var side: Constants.SIDES = Constants.SIDES.ATTACKING
@export var slots: Constants.SLOTS = Constants.SLOTS.TARGET
##Ammount of energy per action. -1 means infinite.
@export var energy_ammount: int = 0
##Ammount of swaps actions allowed. -1 means infinite.
@export var swap_ammount: int = 1
##If any energy is currently considered
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var type: int = 2 ** 9 - 1

func play_effect(fundies: Fundies, attacking_targets: Array[PokeSlot], defender_targets: Array[PokeSlot]):
	print("PLAY ENMOV")
