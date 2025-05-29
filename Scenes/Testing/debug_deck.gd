@icon("res://Art/ProjectSpecific/alpha.png")
extends Control

@export var search_identifiers: Array[Identifier]
@export var slot_asks: Array[SlotAsk]

@onready var dummy: Dummy = $FullUI/Dummy
@onready var fundies: Fundies = $Fundies
@onready var slots: Array[Node] = $Fundies/Slots.get_children()
@onready var card_resources: Deck_Manipulator = $Fundies/PlayerResources
@onready var slotUI: SlotUIActions = $Fundies/SlotUIActions
@onready var playerSide: Control = $FullUI/PlayerSide
@onready var reveal_slot: Button = $FullUI/PlayerSide/Non_mon/SideDisplay
@onready var search_types: OptionButton = $FullUI/CardActions/SearchTypes
@onready var ask_types: OptionButton = $FullUI/CardActions/AskTypes

func _ready():
	slotUI.group_refresh()
	card_resources.show_reveal_stack(reveal_slot)

func _on_draw_pressed():
	card_resources.draw()

func _on_draw_starting_pressed():
	card_resources.draw_starting()

func _on_discard_pressed():
	SignalBus.show_list.emit(true, "Discard", "Look")

func _on_search_deck_pressed():
	SignalBus.show_list.emit(true, "Deck", "Tutor")

func _on_hand_pressed():
	SignalBus.show_list.emit(true, "Hand", "Play")

func _on_search_discard_pressed():
	SignalBus.show_list.emit(true, "Discard", "Tutor")

func _on_shuffle_2_deck_pressed():
	pass # Replace with function body.

func _on_view_all_deck_pressed():
	SignalBus.show_list.emit(true, "Deck", "Look")

func _on_search_test_pressed() -> void:
	print(search_identifiers[search_types.get_selected_id()], search_types.get_item_text(search_types.get_selected_id()))
	var identifier: Identifier = search_identifiers[search_types.get_selected_id()]
	match search_types.get_selected_id():
		7: #Evolves from active
			identifier.edit_in_type(slots[0].type)
		8: #Pokemon of type
			identifier.edit_in_type(dummy.get_type_flag())
		9: #Energy of type
			identifier.edit_in_type(dummy.get_type_flag())
	card_resources.identifier_search(card_resources.arrays.get_array("Deck"), slots[0], search_identifiers[search_types.get_selected_id()])

func _on_ask_test_pressed() -> void:
	pass # Replace with function body.
