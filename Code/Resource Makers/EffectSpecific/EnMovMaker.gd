@icon("res://Art/ProjectSpecific/swap.png")
extends Resource
class_name EnMov

##[enum Send] takes attatched energy and moves it to the [member to_stack][br]
##[enum Swap] takes attatched energy and looks for a second candidate to attatch it to[br]
##[enum Attatch] Using energy found in [member to_stack] attatch energy to this mon 
@export_enum("Send", "Swap", "Attatch") var action: int = 0
##If the chooser is [enum Constants.SIDES.NONE], then default to [enum Constants.SIDES.SOURCE]
@export var chooser: Constants.SIDES = Constants.SIDES.SOURCE
@export var givers: SlotAsk = preload("res://Resources/Components/Effects/Asks/FromSource.tres")
@export_group("From - To")
##If they targets from slot ask will determine if they're allowed
@export var reciever: SlotAsk = preload("res://Resources/Components/Effects/Asks/FromSource.tres")
##Targets for removal
@export var to_stack: Constants.STACKS = Constants.STACKS.DISCARD
@export_enum("Top", "Bottom", "Eh") var stack_direction: int = 2
@export_group("Energy")
##If this is true, instead limit actions based on number of energy allowed to swap
@export var energy_carry_over: bool = false
##How many times are you allowed to perform [member action]. -1 means infinite
@export var action_ammount: int = 1
##Ammount of energy per action. -1 means infinite.
@export var energy_ammount: int = 1
@export_enum("Basic", "Special", "Any") var energy_move_type: int = 0
@export var react: bool = false
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
	var new_box: SwapBox = Constants.swap_box.instantiate()
	#Globals.fundies.get_considered_home(chooser)
	new_box.swap_rules = self
	new_box.side = Globals.full_ui.get_side(givers.side_target)
	new_box.singles = Globals.full_ui.singles
	Globals.fundies.add_child(new_box)
	await new_box.finished
	
	finished.emit()

func swap(giver: PokeSlot, reciever: PokeSlot, energy_giving: Array[Base_Card]):
	var left: Array[Base_Card] = energy_giving.duplicate()
	
	for en in energy_giving:
		for card in giver.energy_cards:
			if card.same_card(en):
				left.erase(en)
				giver.energy_cards.erase(en)
				break
	
	if left.size() != 0:
		printerr(left," has ",left.size()," cards left")
	
	for en in energy_giving:
		reciever.add_energy(en)
	
	reciever.count_energy()
	giver.count_energy()
	giver.refresh()

func attatch_effect():
	finished.emit()

func energy_allowed(card: Base_Card, fail: bool) -> bool:
	@warning_ignore("incompatible_ternary")
	var provides: int = card.energy_properties.fail_provide if fail else card.energy_properties.type
	var same: bool = energy_move_type == 2 or\
	 (energy_move_type == 1 and card.energy_properties.considered == "Special Energy")\
	 or (energy_move_type == 0 and card.energy_properties.considered == "Basic Energy")
	var is_react: bool = (react and react == card.energy_properties.react) or not react
	
	return provides & type != 0 and same and is_react

func enough_energy(ammount: int) -> bool:
	return energy_ammount != -1 and ammount == energy_ammount 

func enough_actions(ammount: int) -> bool:
	return action_ammount != -1 and ammount == action_ammount
