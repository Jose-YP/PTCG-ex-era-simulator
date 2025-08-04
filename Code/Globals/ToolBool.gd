@tool
extends Node

func has_ability(card: Base_Card) -> bool:
	var mon: Pokemon = card.pokemon_properties
	if mon:
		return mon.pokebody or mon.pokepower
	else:
		return false
