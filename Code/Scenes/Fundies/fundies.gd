@icon("res://Art/ProjectSpecific/cards.png")
extends Node
class_name Fundies

#--------------------------------------
#region VARIABLES
@export var board: BoardNode
@export var first_turn: bool = false
@export var attatched_energy: bool = false

@onready var ui_actions: SlotUIActions = $UIActions
@onready var stack_manager: StackManager = $StackManager
@onready var card_player: CardPlayer = $CardPlayer
@onready var pass_turn_graphic: Control = $PassTurnGraphic

var turn_number: int = 1
var home_turn: bool = true
var current_list: Control
var home_targets: Array[Array]
var away_targets: Array[Array]
var source_stack: Array[bool]
var used_abilities: Array[String]
var cpu_players: Array[CPU_Player]
var options: ItemOptions

#endregion
#--------------------------------------

func _ready() -> void:
	Globals.fundies = self
	SignalBus.end_turn.connect(next_turn)

#--------------------------------------
#region PRINT
func current_turn_print():
	#Get the side that's attacking
	print("CURRENT ATTACKER")
	Globals.full_ui.get_home_side(home_turn).print_status()
	
	#Get the side that's defending
	print("CURRENT DEFENDER")
	Globals.full_ui.get_home_side(not home_turn).print_status()
	
	print_simple_slot_types()

func print_simple_slot_types():
	print("-------------------------")
	#GET ATTACKING
	print_slots(Consts.SIDES.ATTACKING, Consts.SLOTS.ALL, "ATTACKING SLOTS: ")
	print_slots(Consts.SIDES.DEFENDING, Consts.SLOTS.ALL, "DEFENDING SLOTS: ")
	print_slots(Consts.SIDES.BOTH, Consts.SLOTS.ACTIVE, "ACTIVE SLOTS: ")
	print_slots(Consts.SIDES.BOTH, Consts.SLOTS.BENCH, "BENCH SLOTS: ")
	print("-------------------------")

func print_slots(sides: Consts.SIDES, slots: Consts.SLOTS, init_string: String):
	var slot_string: String = init_string
	for slot in Globals.full_ui.get_slots(sides, slots):
		if not slot.connected_slot.is_filled():
			continue
		slot_string = str(slot_string, "[", slot.connected_slot.current_card.name, "]")
	
	print(slot_string, "\n")
#endregion
#--------------------------------------

#--------------------------------------
#region HELPERS
func hide_list() -> void:
	if current_list: Globals.control_disapear(current_list, .1, current_list.old_pos)

func get_side_ui() -> CardSideUI:
	return Globals.full_ui.get_home_side(home_turn)

func get_considered_home(side: Consts.SIDES):
	match side:
		Consts.SIDES.ATTACKING:
			return home_turn
		Consts.SIDES.DEFENDING:
			return not home_turn
		Consts.SIDES.SOURCE:
			return get_source_considered()
		Consts.SIDES.OTHER:
			return not get_source_considered()

func is_home_side_player() -> bool:
	var check_side = board.board_state.home_side\
	 if home_turn else board.board_state.away_side
	
	return check_side == Consts.PLAYER_TYPES.PLAYER

func get_current_player():pass

func can_be_played(card: Base_Card) -> int:
	var considered: int = Convert.get_card_flags(card)
	var allowed_to: int = 0
	#Basic
	if considered & 1 != 0 and find_allowed_slots(func(slot: PokeSlot): 
		return not slot.is_filled(),
		Consts.SIDES.ATTACKING).size() != 0:
			allowed_to += 1
	#Evo
	if considered & 2 != 0:
		var can_evo_from = Globals.make_can_evo_from(card)
		if find_allowed_slots(can_evo_from, Consts.SIDES.ATTACKING).size() != 0:
			allowed_to += 2
		else:
			print(card.name, " can't evolve from any current slot")
	#Item
	if considered & 4 != 0:
		allowed_to += 4
	#Supporter
	if considered & 8 != 0:
		if (not Globals.full_ui.get_home_side(home_turn).supporter_played() and not first_turn)\
		 or Globals.board_state.debug_unlimit:
			allowed_to += 8
	#Stadium
	if considered & 16 != 0:
		allowed_to += 16
	#Tool
	if considered & 32 != 0:
		if find_allowed_slots(func (slot: PokeSlot):\
		 return slot.tool_card == null, Consts.SIDES.ATTACKING).size() != 0:
			allowed_to += 32
	#TM
	if considered & 64 != 0:
		allowed_to += 64
	#RSM
	if considered & 128 != 0:
		allowed_to += 128
	#Fossil
	if considered & 256 != 0 and find_allowed_slots(func(slot: PokeSlot):
		return not slot.is_filled(),
		Consts.SIDES.ATTACKING).size() != 0:
			allowed_to += 256
	#Energy
	if (considered & 512 and not attatched_energy) or Globals.board_state.debug_unlimit:
		allowed_to += 512
	return allowed_to

func used_ability(ability_name: String) -> bool:
	for ability in used_abilities:
		if ability == ability_name:
			return true
	
	return false

#endregion
#--------------------------------------

#--------------------------------------
#region SLOT FUNCTIONS
func find_allowed_slots(condition: Callable, sides: Consts.SIDES,\
 slots: Consts.SLOTS = Consts.SLOTS.ALL) -> Array[UI_Slot]:
	return Globals.full_ui.get_slots(sides, slots).filter(func(uislot: UI_Slot):\
	 return condition.call(uislot.connected_slot))

func get_poke_slots(sides: Consts.SIDES = Consts.SIDES.BOTH, 
 slots: Consts.SLOTS = Consts.SLOTS.ALL) -> Array[PokeSlot]:
	var array: Array[PokeSlot]
	for ui_slot in Globals.full_ui.get_slots(sides, slots):
		array.append(ui_slot.connected_slot)
	return array

func check_ask_on_all(ask: SlotAsk) -> bool:
	for slot in get_poke_slots():
		if ask.check_ask(slot):
			return true
	
	return false

#region TARGET SOURCE MANAGEMENT
func record_attack_src_trg(is_home: bool, atk_trg: Array, def_trg: Array):
	source_stack.append(is_home)
	if is_home:
		home_targets.append(atk_trg)
		away_targets.append(def_trg)
	else:
		home_targets.append(def_trg)
		away_targets.append(atk_trg)
	print_src_trg()

#First record then print out what I can get from this, then rmeove when used up
func record_source_target(is_home: bool, home_trg: Array, away_trg: Array):
	source_stack.append(is_home)
	home_targets.append(home_trg)
	away_targets.append(away_trg)
	print_src_trg()

func record_single_src_trg(slot: PokeSlot):
	var home_trg: Array = []
	var away_trg: Array = []
	var is_home: bool = slot.is_home()
	
	if is_home: home_trg.append(slot)
	else: away_trg.append(slot)
	
	record_source_target(is_home, home_trg, away_trg)

func remove_top_source_target():
	source_stack.pop_back()
	home_targets.pop_back()
	away_targets.pop_back()

func get_targets() -> Array:
	return home_targets[-1] + away_targets[-1]

func get_source_considered() -> bool:
	return source_stack[-1]

func print_src_trg():
	print_slots(Consts.SIDES.SOURCE, Consts.SLOTS.ALL, "SOURCE SLOTS: ")
	print_slots(Consts.SIDES.BOTH, Consts.SLOTS.TARGET, "TARGET SLOTS: ")

#endregion
#endregion
#--------------------------------------

func next_turn():
	print_rich("[center]--------------------------END TURN-------------------------")
	home_turn = not home_turn
	attatched_energy = false
	turn_number += 1
	await Globals.full_ui.set_between_turns()
	#When animations and other stuff are added for checkups, remove this
	await get_tree().create_timer(.1).timeout
	print_rich("[center]--------------------------TURN ", turn_number, "-------------------------")
	pass_turn_graphic.turn_change()
	await pass_turn_graphic.animation_player.animation_finished
	
	for player in cpu_players:
		player.can_operate()
