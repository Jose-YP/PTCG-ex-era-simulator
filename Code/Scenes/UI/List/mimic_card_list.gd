@icon("res://Art/Energy/48px-Darkness-attack.png")
extends Control
class_name MimicCardList

@export var stack: Consts.STACKS = Consts.STACKS.HAND

@onready var header: HBoxContainer = %Header
@onready var footer: PanelContainer = %Footer
@onready var playing_list: PlayingList = %PlayingList
@onready var attack_list: AttackScrollContainer = %Attacks
@onready var old_size: Vector2 = size

const stack_act: Consts.STACK_ACT = Consts.STACK_ACT.MIMIC
const header_txt: String = "[center]MIMIC BOX"

var target: PokeSlot
var list: Dictionary[Base_Card, bool]
var home: bool
var shuffle: bool
var must_pay_energy: bool
var selected_attack: Attack

signal finished

#Mimic
#Mainly used for PK97 Shiftry ex, I don't know if anyone else does this
func _ready():
	playing_list.list = list
	playing_list.set_items()
	playing_list.sort_items()
	attack_list.poke_slot = target
	attack_list.pay_costs = must_pay_energy
	header.setup(header_txt)
	
	for button in playing_list.get_items():
		button.pressed.connect(manage_pressed.bind(button))

func allow_reverse():
	%Header.closable = true

func manage_pressed(button: PlayingButton):
	if button.selected:
		button.selected = false
		%Attacks.reset_items()
	else:
		button.selected = true
		%Attacks.current_card = button.card
		%Attacks.set_specific_items(button.card.pokemon_properties.attacks)

func _on_header_close_button_pressed() -> void:
	if %Header.closable:
		SignalBus.went_back.emit()
		finished.emit()
	else: push_error("Closed when shouldn't be able to")

func _on_attack_pressed() -> void:
	finished.emit()
