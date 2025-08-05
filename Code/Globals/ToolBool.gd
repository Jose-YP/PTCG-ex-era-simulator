@tool
extends Node

func has_ability(card: Base_Card) -> bool:
	var mon: Pokemon = card.pokemon_properties
	if mon:
		return mon.pokebody or mon.pokepower
	else:
		return false

#Might never finish, depend on how much I need this
func has_effect(card: Base_Card, effect_type: String):
	if card.pokemon_properties:
		for attack in card.pokemon_properties:
			if attack.has_effect(effect_type):
				return true
		if card.pokemon_properties.pokebody or card.pokemon_properties.pokepower:
			return true
		
	if card.trainer_properties:
		pass
	if card.energy_properties:
		pass
	return false
