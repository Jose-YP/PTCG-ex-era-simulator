@icon("res://Art/ProjectSpecific/alpha.png")
extends Control

@onready var card_resources: Deck_Manipulator = $Fundies/PlayerResources
@onready var slotUI: SlotUIActions = $Fundies/SlotUIActions
@onready var playerSide: Control = $FullUI/PlayerSide
@onready var reveal_slot: Button = $FullUI/PlayerSide/Non_mon/SideDisplay

func _ready():
	slotUI.group_refresh()
	card_resources.show_reveal_stack(reveal_slot)

func _on_draw_pressed():
	card_resources.draw()

func _on_draw_starting_pressed():
	card_resources.draw_starting()

func _on_discard_pressed():
	pass # Replace with function body.

func _on_search_deck_pressed():
	pass # Replace with function body.

func _on_hand_pressed():
	print(card_resources.hand)
	SignalBus.show_list.emit("Player1", "Hand")

func _on_search_discard_pressed():
	pass # Replace with function body.

func _on_shuffle_2_deck_pressed():
	pass # Replace with function body.

func _on_view_all_deck_pressed():
	pass # Replace with function body.


func _on_active_pokemon_ready() -> void:
	pass # Replace with function body.

func _on_full_ui_ready() -> void:
	pass # Replace with function body.


func _on_fundies_ready() -> void:
	pass # Replace with function body.


func _on_ready() -> void:
	pass # Replace with function body.
