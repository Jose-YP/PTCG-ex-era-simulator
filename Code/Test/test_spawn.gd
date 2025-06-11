extends Control


func _on_button_pressed() -> void:
	var option_scene := load("res://Scenes/UI/Lists/item_options_copy.tscn") as PackedScene
	var option_display := option_scene.instantiate() as Node

	# Check if the script is present
	print("Script attached:", option_display.get_script())
