@icon("res://Art/ProjectSpecific/alpha.png")
extends Control

@export var searches: Array[Search]
@export var search_identifiers: Array[Identifier]
@export var slot_asks: Array[SlotAsk]
@export var switch_types: Array[Base_Card]
@export var en_mov_types: Array[EnMov]
@export var effect_template: EffectCall

@onready var dummy: Dummy = $FullUI/Dummy
@onready var fundies: Fundies = $Fundies
@onready var slots: Array[Node] = $Fundies/Slots.get_children()
@onready var card_resources: Deck_Manipulator = $Fundies/PlayerResources
@onready var slotUI: SlotUIActions = $Fundies/SlotUIActions
@onready var playerSide: Control = $FullUI/PlayerSide
@onready var reveal_slot: Button = $FullUI/PlayerSide/Non_mon/SideDisplay
@onready var identifier_types: OptionButton = $FullUI/CardActions/IdentifierTypes
@onready var search_types: OptionButton = $FullUI/CardActions/SearchTypes
@onready var ask_types: OptionButton = $FullUI/CardActions/AskTypes
@onready var switch_options: OptionButton = $FullUI/CardActions/SwitchOptions
@onready var en_move_options: OptionButton = $FullUI/CardActions/EnMoveOptions

const castaway: Base_Card = preload("res://Resources/Cards/14 ex Crystal Guardians/CG72Castaway.tres")

func _ready():
	slotUI.group_refresh()
	card_resources.show_reveal_stack(reveal_slot)

#region SIGNALS 
func _on_draw_pressed():
	card_resources.draw()

func _on_draw_starting_pressed():
	card_resources.draw_starting()

func _on_discard_pressed():
	print()
	SignalBus.show_list.emit(true, Constants.STACKS.HAND, Constants.STACK_ACT.DISCARD)

func _on_shuffle_2_deck_pressed():
	pass # Replace with function body.

func template_search():
	effect_template = EffectCall.new()
	effect_template.search = searches[search_types.get_selected_id()]
	effect_template.play_effect(fundies, [], [])

func _on_ask_test_pressed() -> void:
	pass # Replace with function body.

func _on_switch_test_pressed() -> void:
	SignalBus.play_trainer.emit(switch_types[switch_options.get_selected_id()])

func _on_en_mov_test_pressed() -> void:
	effect_template = EffectCall.new()
	effect_template.energy_movement = en_mov_types[en_move_options.get_selected_id()]
	effect_template.play_effect(fundies, [], [])
#endregion
