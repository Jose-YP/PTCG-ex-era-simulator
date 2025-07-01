@icon("res://Art/ProjectSpecific/swap.png")
extends Control
class_name SwapBox

@export var side: CardSideUI
@export var singles: bool = true

@onready var playing_list: PlayingList = %PlayingList
@onready var slot_list: SlotList = %SlotList
@onready var header: HBoxContainer = %Header
@onready var identifier_panel_2: PanelContainer = %IdentifierPanel2

enum STEP {GIVER, ENERGY, RECIECVER}

signal finished

const stack = Constants.STACKS.PLAY
const stack_act = Constants.STACK_ACT.ENSWAP

var swap_rules: EnMov
var energy_left: int
var swaps_left: int
var giver: PokeSlot
var reciever: PokeSlot
var energy_given: Array[Base_Card]

func _ready() -> void:
	slot_list.side = side
	slot_list.singles = singles
	
	slot_list.setup()
	for button in slot_list.slots:
		button.pressed.connect(get_swappable.bind(button.slot))
	
	header.setup("SWAP BOX")
	if swap_rules == null:
		var default_effect: EffectCall = load("res://Resources/Components/Effects/EnergyMovement/AtkSwapBasic.tres")
		swap_rules = default_effect.energy_movement

func setup():
	pass

func get_swappable(slot: PokeSlot):
	playing_list.reset_items()
	var energy_dict: Dictionary[Base_Card, bool] = {}
	
	for card in slot.energy_cards:
		#Asume true for now, make a function to see if it fails or not later
		energy_dict[card] = swap_rules.energy_allowed(card, false)
		print(card.name, energy_dict[card])
	
	playing_list.list = energy_dict
	playing_list.all_lists = [energy_dict]
	playing_list.set_items()
	%Instructions.clear()
	%Instructions.append_text(str("Choose cards to swap from ", slot.current_card.name))

func _on_end_pressed() -> void:
	pass # Replace with function body.
