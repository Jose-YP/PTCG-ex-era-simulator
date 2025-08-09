@tool
extends Node

func _ready():
	#Make two edits and saves on prompt so I don't have to think about it every time I load
	#Make a branch before trying to make this
	pass

func is_empty(card: Base_Card) -> bool:
	if card.pokemon_properties:
		return false
	if card.trainer_properties:
		return false
	if card.energy_properties:
		return false
	return true

func has_ability(card: Base_Card) -> bool:
	var mon: Pokemon = card.pokemon_properties
	if mon:
		return mon.pokebody or mon.pokepower
	else:
		return false

#Might never finish, depend on how much I need this
func has_effect(card: Base_Card, effect_type: Array[String]):
	if card.pokemon_properties:
		var mon: Pokemon = card.pokemon_properties
		for attack in mon.attacks:
			if attack_has_effect(attack,effect_type):
				return true
		if mon.pokebody != null:
			if mon.pokebody.passive != null:
				if effect_has_effect_type(mon.pokebody.passive, effect_type):
					return true
			if mon.pokebody.effect != null:
				if effect_has_effect_type(mon.pokebody.effect, effect_type):
					return true
			if mon.pokebody.prompt != null:
				if mon.pokebody.prompt.effect != null:
					if effect_has_effect_type(mon.pokebody.prompt.effect, effect_type):
						return true
		if mon.pokepower != null:
			if mon.pokepower.passive:
				if effect_has_effect_type(mon.pokepower.passive, effect_type):
					return true
			if mon.pokepower.effect:
				if effect_has_effect_type(mon.pokepower.effect, effect_type):
					return true
			if mon.pokepower.prompt != null:
				if mon.pokepower.prompt.effect != null:
					if effect_has_effect_type(mon.pokepower.prompt.effect, effect_type):
						return true
	if card.trainer_properties:
		var train: Trainer = card.trainer_properties
		if train.success_effect != null:
			if effect_has_effect_type(train.success_effect,effect_type):
				return true
		if train.fail_effect != null:
			if effect_has_effect_type(train.fail_effect,effect_type):
				return true
		if train.always_effect != null:
			if effect_has_effect_type(train.always_effect,effect_type):
				return true
		if train.prompt != null:
			if train.prompt.effect != null:
				if effect_has_effect_type(train.prompt.effect,effect_type):
					return true
		if train.provided_attack != null:
			if attack_has_effect(train.provided_attack, effect_type):
				return true
		if train.tool_properties != null:
			pass
		if train.stadium_properties != null:
			pass
	if card.energy_properties:
		var en: Energy = card.energy_properties
		if en.success_effect != null:
			if effect_has_effect_type(en.success_effect, effect_type):
				return true
		if en.fail_effect != null:
			if effect_has_effect_type(en.fail_effect, effect_type):
				return true
		if en.attatch_effect != null:
			if effect_has_effect_type(en.attatch_effect, effect_type):
				return true
		if en.prompt != null:
			if en.prompt.effect != null:
				if effect_has_effect_type(en.prompt.effect, effect_type):
					return true
	return false

func attack_has_effect(attack: Attack, comps: Array[String]):
	var data: AttackData = attack.attack_data
	if data.fail_effect != null:
		if effect_has_effect_type(data.fail_effect, comps):
			return true
	if data.success_effect != null:
		if effect_has_effect_type(data.success_effect, comps):
			return true
	if data.always_effect != null:
		if effect_has_effect_type(data.always_effect, comps):
			return true
	if data.prompt != null:
		if data.prompt.effect != null:
			if effect_has_effect_type(data.prompt.effect, comps):
				return true
	return false

func effect_has_effect_type(effect: EffectCall, comps: Array[String]):
	if effect == null:
		print("oh")
		return false
	
	var gathered_comps: Array = []
	for comp in comps:
		match comp:
			"Condition":
				if effect.condition:
					gathered_comps.append(effect.condition)
			"Buff":
				if effect.buff:
					gathered_comps.append(effect.buff)
			"CardDisrupt":
				if effect.card_disrupt:
					gathered_comps.append(effect.card_disrupt)
					return true
			"Disable":
				if effect.disable:
					gathered_comps.append(effect.disable)
			"EnMov":
				if effect.energy_movement:
					gathered_comps.append(effect.energy_movement)
			"DmgManip":
				if effect.dmgManip:
					gathered_comps.append(effect.dmgManip)
			"Search":
				if effect.search:
					gathered_comps.append(effect.search)
			"Swap":
				if effect.swap:
					gathered_comps.append(effect.swap)
			"Draw":
				if effect.draw_ammount:
					gathered_comps.append(effect.draw_ammount)
			"Alleviate":
				if effect.alleviate:
					gathered_comps.append(effect.alleviate)
			"Mimic":
				if effect.mimic:
					gathered_comps.append(effect.mimic)
			"Extra":
				if effect.extra_effect:
					gathered_comps.append(effect.extra_effect)
	
	for current_comp in gathered_comps:
		if current_comp.get_script().get_global_name() in comps:
			print("THERE")
			return true
	
	#if effect.prompt_extra:
		#if effect.prompt_extra.effect:
			#if effect_has_effect_type(effect.prompt_extra.effect, comps):
				#return true
	#if effect.extra_effect:
		#if effect_has_effect_type(effect.extra_effect, comps):
			#return true
	
	return false
