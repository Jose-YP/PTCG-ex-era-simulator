@tool
@icon("res://Art/ProjectSpecific/cards.png")
extends Node
class_name Fundies

@export var player_side: CardSideUI
@export var deck: Deck

@onready var slot_ui_actions: SlotUIActions = $SlotUIActions
@onready var player_resources: Deck_Manipulator = $PlayerResources
@onready var on_slot_actions: On_Slot_Actions = $OnSlotActions
@onready var poke_slots: Array[PokeSlot] = [$Slots/PokeSlot, $Slots/PokeSlot2,
 $Slots/PokeSlot3, $Slots/PokeSlot4, $Slots/PokeSlot5, $Slots/PokeSlot6]
@onready var opp_slots: Array[PokeSlot]

var turn_number: int = 1
var current_turn: Constants.PLAYER_TYPES
var ui_slots: Array[UI_Slot]
var active_slots: Array[PokeSlot]
var bench_slots: Array[PokeSlot]
var current_list: Node
var attacker: PokeSlot
var defender: PokeSlot
var attacking_targets: Array[Array]
var defending_targets: Array[Array]
var current_source: Array[Constants.PLAYER_TYPES]

#region INITALIZATION
func _get_configuration_warnings() -> PackedStringArray:
	if player_side == null:
		return ["Setup the node Fundies should connect to"]
	if deck == null:
		return ["Fundies needs a deck to operate on, otherwise it will use the debug deck"]
	else:
		return []

func _ready() -> void:
	ui_slots = player_side.get_slots()
	player_resources.deck = deck
	ui_slots = player_side.ui_slots
	for i in range(poke_slots.size()):
		poke_slots[i].ui_slot = player_side.ui_slots[i]
		
		if player_side.ui_slots[i].active:
			active_slots.append(poke_slots[i])
		else: bench_slots.append(poke_slots[i])
#endregion

func hide_list():
	if current_list: current_list.disapear()

#region BOARDWIDE FUNCTIONS
func get_slots(side_type: Constants.SIDES, slot_type: Constants.SLOTS) -> Array[PokeSlot]:
	var returned_slots: Array[PokeSlot]
	
	print("USING SLOTS ")
	if slot_type == Constants.SLOTS.TARGET and side_type == Constants.SIDES.ATTACKING:
		print("ATTACKER ", attacker.name)
		return [attacker]
	
	elif slot_type == Constants.SLOTS.TARGET and side_type == Constants.SIDES.DEFENDING:
		print("DEFENDER ", defender.name)
		return [defender]
	
	else:
		for slot in poke_slots + opp_slots:
			var active: bool = slot.is_active() or slot_type == Constants.SLOTS.ALL
			var side: bool = slot.is_player() or side_type == Constants.SLOTS.ALL
			
			if active and side:
				returned_slots.append(slot)
				print(slot.name)
	
	return returned_slots

func can_be_played(card: Base_Card) -> int:
	var considered: int = Conversions.get_card_flags(card)
	var allowed_to: int = 0
	
	if considered & 1 != 0:
		if find_allowed_slots(func(slot: PokeSlot): return not slot.current_card,\
		Constants.SIDES.ATTACKING).size() != 0:
			allowed_to += 1
	if considered & 2 != 0:
		var can_evo_from = Globals.make_can_evo_from(card)
		
		if find_allowed_slots(can_evo_from, Constants.SIDES.ATTACKING).size() != 0:
			allowed_to += 2
		else:
			print(card.name, " can't evolve from any current slot")
	if considered & 4 != 0:
		pass
	if considered & 8 != 0:
		if not player_resources.supporter_played:
			allowed_to += 8
	if considered & 16 != 0:
		pass
	if considered & 32 != 0:
		pass
	if considered & 64 != 0:
		pass
	if considered & 128 != 0:
		pass
	if considered & 256 != 0:
		if find_allowed_slots(func(slot: PokeSlot): return not slot.current_card,\
		Constants.SIDES.ATTACKING).size() != 0:
			allowed_to += 256
	if considered & 512:
		pass
	return allowed_to

func find_allowed_slots(condition: Callable, side: Constants.SIDES, slot: Constants.SLOTS = Constants.SLOTS.ALL):
	var allowed: Array[UI_Slot]
	for pokeslot in (poke_slots + opp_slots):
		if pokeslot.is_in_slot(side, slot) and condition.call(pokeslot):
			allowed.append(pokeslot.ui_slot)
	
	return allowed

func edit_attacker_defender(new_atk: PokeSlot, new_def: PokeSlot):
	attacker.is_target = false
	defender.is_target = false
	
	attacker = new_atk
	defender = new_def

func pass_turn():
	pass

func check_ask_on_all(ask: SlotAsk) -> bool:
	for slot in poke_slots + opp_slots:
		if ask.check_ask(slot):
			return true
	
	return false

#region TARGET MANAGEMENT
func add_targets(attacking: Array[PokeSlot], defending: Array[PokeSlot]):
	attacking_targets.append(attacking)
	defending_targets.append(defending)

func remove_targets():
	attacking_targets.pop_back()
	defending_targets.pop_back()

func clear_targets():
	attacking_targets.clear()
	defending_targets.clear()

func get_targets() -> Array[PokeSlot]:
	return attacking_targets[-1] + defending_targets[-1]
#endregion

#region SOURCE MANAGEMENT
func record_source(slot: PokeSlot):
	current_source.append(slot.player_type)

func get_source_considered() -> Constants.PLAYER_TYPES:
	return current_source[-1]

func remove_source():
	current_source.pop_back()

func clear_sources():
	current_source = []
#endregion
#endregion
