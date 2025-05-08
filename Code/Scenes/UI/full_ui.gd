extends Control

var current_card: Control

func remove_card() -> void:
	print("IHJBEFDI")


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("A") and Globals.checking:
		remove_card()
