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

var ui_slots: Array[UI_Slot]
var active_slots: Array[PokeSlot]
var bench_slots: Array[PokeSlot]
var current_list: Node
var attacker: PokeSlot
var defender: PokeSlot

#region INITALIZATION
func _get_configuration_warnings() -> PackedStringArray:
	if player_side == null:
		return ["Setup the node Fundies should connect to"]
	if deck == null:
		return ["Fundies needs a deck to operate on, otherwise it will use the debug deck"]
	else:
		return []

func _ready() -> void:
	ui_slots = player_side.ui_slots
	player_resources.deck = deck
	
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
#endregion
