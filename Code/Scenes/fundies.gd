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

var ui_slots: Array[UI_Slot]
var active_slots: Array[PokeSlot]
var bench_slots: Array[PokeSlot]
var current_list: Node

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

func hide_list():
	if current_list: current_list.disapear()
