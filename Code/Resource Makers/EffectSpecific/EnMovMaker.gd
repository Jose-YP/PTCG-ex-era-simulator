@icon("res://Art/ProjectSpecific/swap.png")
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
##How many times are you allowed to perform [member action]. -1 means infinite
@export var action_ammount: int = 0
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
	match action:
		0:
			await move_effect()
		1:
			await swap_effect()
		2:
			await attatch_effect()
	
	finished.emit()

func move_effect():
	finished.emit()

func swap_effect():
	#var new_box: SwapBox = Constants.swap_box.instantiate()
	
	#new_box.swap_rules = self
	
	#Globals.fundies.add_child(new_box)
	#await new_box.finished
	finished.emit()

func attatch_effect():
	finished.emit()

func energy_allowed(card: Base_Card, fail: bool) -> bool:
	@warning_ignore("incompatible_ternary")
	var provides: int = card.energy_properties.fail_provide if fail else card.energy_properties.type
	var same: bool = energy_move_type == 2 or\
	 (energy_move_type == 1 and card.energy_properties.considered == "Special Energy")\
	 or (energy_move_type == 0 and card.energy_properties.considered == "Basic Energy")
	
	return provides & type != 0 and same

func enough_energy(ammount: int) -> bool:
	return energy_ammount != -1 and ammount == energy_ammount 

func enough_actions(ammount: int) -> bool:
	return action_ammount != -1 and ammount == action_ammount
