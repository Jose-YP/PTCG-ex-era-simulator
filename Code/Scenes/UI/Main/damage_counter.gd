@icon("res://Art/Counters/Spiral.png")
extends Control

@export var damage_gradient: Gradient
@export var max_practical: float = 200.0
@export var max_purple: float = 300.0

func _ready() -> void:
	set_damage(0)

func set_damage(dmg: int) -> void:
	visible = dmg != 0
	%DmgText.clear()
	%DmgText.append_text(str("[b][i][color=black]",dmg))
	
	if dmg < max_practical:
		%DmgCounter.modulate = damage_gradient.sample(float(dmg/max_practical) * damage_gradient.get_offset(1))
	else:
		%DmgCounter.modulate = damage_gradient.sample(float(clamp(dmg,0,300)/max_purple))
