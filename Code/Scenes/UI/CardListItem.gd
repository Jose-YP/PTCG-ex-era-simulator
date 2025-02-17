extends Button

@export var card: Base_Card

func _ready() -> void:
	%Class.clear()
	if card.categories & 1:
		%Class.append_text(card.pokemon_properties.evo_stage)
	elif card.categories & 2:
		var considered = card.trainer_properties.considered
		if considered == "Supporter":
			considered = "Support"
		
		%Class.append_text(considered)
	else:
		%Class.append_text(card.energy_properties.considered)
	
	%Art.texture = card.image
	%Name.clear()
	%Name.append_text(card.name)

func is_allowed() -> void:
	pass
