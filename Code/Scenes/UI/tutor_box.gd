extends Control

@export var connected_list: PlayingList

var current_tutor: Array[Base_Card]
var max_tutor: int = 0

func _ready() -> void:
	pass

func update_tutor():
	pass

func _on_confirm_pressed() -> void:
	SignalBus.swap_card_location.emit

func _on_cancel_pressed() -> void:
	pass # Replace with function body.
