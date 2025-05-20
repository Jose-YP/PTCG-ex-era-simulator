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
