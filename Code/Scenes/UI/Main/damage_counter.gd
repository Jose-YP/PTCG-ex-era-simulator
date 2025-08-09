@icon("res://Art/Counters/Spiral.png")
extends Control
class_name DamageCounter

@export var slot_item: bool = false

@export var damage_gradient: Gradient
@export var heal_gradient: Gradient
@export var max_practical: float = 200.0
@export var max_purple: float = 300.0

var current_dmg: int = 0

func _ready() -> void:
	set_damage(0)

func set_damage(dmg: int) -> void:
	%DmgText.clear()
	%DmgText.append_text(str("[b][i][color=black]", abs(dmg)))
	
	if dmg > 0 and dmg < max_practical:
		%DmgCounter.modulate = damage_gradient.sample(float(dmg/max_practical) * damage_gradient.get_offset(1))
	elif dmg < 0:
		%DmgCounter.modulate = heal_gradient.sample(float(dmg/max_practical) * heal_gradient.get_offset(1))
	else:
		%DmgCounter.modulate = damage_gradient.sample(float(clamp(dmg,0,300)/max_purple))
	
	if dmg == 0:
		%DmgCounter.modulate = Color(%DmgCounter.modulate, 0)
		%DmgText.hide()
	else:
		%DmgCounter.modulate = Color(%DmgCounter.modulate, 1)
		%DmgText.show()
	
	current_dmg = dmg
