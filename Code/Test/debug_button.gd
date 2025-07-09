extends Button

@export var spawning_debug: PackedScene

var current: Control

func _on_pressed() -> void:
	if current:
		Globals.control_disapear(current, .1)
	else:
		spawn_debug()

func spawn_debug():
	var debug: Control = spawning_debug.instantiate()
	var debug_tween: Tween = get_tree().create_tween()
	add_child(debug)
	
	debug.top_level = true
	debug.scale = Vector2.ZERO
	
	debug_tween.tween_property(debug, "scale", Vector2.ONE, .1)
	debug_tween.tween_property(debug, "global_position", get_global_mouse_position(), .1)
