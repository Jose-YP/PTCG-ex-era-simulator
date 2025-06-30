extends Resource
class_name EnMov

##[enum Move] takes attatched energy and moves it to the [member to_stack][br]
##[enum Swap] takes attatched energy and looks for a second candidate to attatch it to[br]
##[enum Attatch] Using energy found in [member to_stack] attatch energy to this mon 
@export_enum("Move", "Swap", "Attatch") var action: int = 0
##If the chooser is [enum Constants.SIDES.NONE], then default to [member side]
@export var chooser: Constants.SIDES = Constants.SIDES.SOURCE
@export_group("From - To")
##If they targets from which meet ask, they're allowed
@export var candidates: SlotAsk
##Targets for removal
@export var side: Constants.SIDES = Constants.SIDES.ATTACKING
@export var slots: Constants.SLOTS = Constants.SLOTS.TARGET
@export var to_stack: Constants.STACKS = Constants.STACKS.DISCARD
@export_enum("Top", "Bottom", "Eh") var stack_direction: int = 2
@export_group("Energy")
##Ammount of energy per action. -1 means infinite.
@export var energy_ammount: int = 0
@export_enum("Basic", "Special", "Any") var energy_move_type: int = 0
##If any energy is currently considered
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var type: int = 2 ** 9 - 1

signal finished

func play_effect():
	print("PLAY ENMOV")
	
	finished.emit()
