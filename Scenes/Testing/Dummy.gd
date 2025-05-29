@icon("res://Art/ProjectSpecific/icon.svg")
extends Control
class_name Dummy

@onready var energy_options: OptionButton = $DummyActions/EnergyOptions
@onready var option_button: OptionButton = $DummyActions/OptionButton

func _ready():
	$PokeSlot.refresh()

func get_type_flag():
	return 2 ** energy_options.selected

func _on_set_type_pressed():
	pass # Replace with function body.

func _on_set_weakness_pressed():
	pass # Replace with function body.

func _on_set_resistance_pressed():
	pass # Replace with function body.

func _on_add_energy_pressed():
	pass # Replace with function body.

func _on_remove_energy_pressed():
	pass # Replace with function body.

func _on_add_condtion_pressed():
	pass # Replace with function body.

func _on_clear_conditions_pressed():
	pass # Replace with function body.
