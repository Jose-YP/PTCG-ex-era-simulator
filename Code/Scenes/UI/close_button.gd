@icon("res://Art/ExpansionIcons/SetSymbolTeam_Magma_vs_Team_Aqua.png")
extends Button
class_name Close_Button

func _on_pressed() -> void:
	await closing_animation()
	owner.queue_free()

func closing_animation() -> void:
	var closing_tween: Tween = create_tween().set_parallel()
	
	closing_tween.tween_property(owner, "scale", Vector2.ZERO, .1)
	closing_tween.tween_property(owner, "modulate", Color.TRANSPARENT, .1)
	
	await closing_tween.finished
