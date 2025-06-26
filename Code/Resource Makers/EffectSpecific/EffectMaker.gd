extends Resource
class_name EffectCall


enum effect_types{CONDITION, BUFF, DISRUPT, DISABLE, 
ENMOV, DMGMANIP, SEARCH, SWAP, DRAW, ALLEVIATE, MIMIC, OTHER}

@export var either_or: bool = false
##Determine the order in which the effects are called.
##It's best to fill this in, if you don't want the default enum order
@export var order: Array[effect_types]
##Add a condition
@export var condition: Condition
##Draw an ammount of cards
@export var draw_ammount: Draw
##Buff/Debuff a pokemon's stats or properties
@export var buff: Buff
##Send cards elsewhere
@export var card_disrupt: CardDisrupt
##Disable the player/pokemon's possible moves
@export var disable: Disable
##Move current energy in play
@export var energy_movement: EnMov
##Move/Add damage counters around slots and stacks
@export var dmgManip: DamageManip
##Look for cards in deck/discard
@export var search: Search
##Heal from any status
@export var alleviate: Alleviate
##Swap the active pokemon
@export var swap: PokeSwap
##Mimic other pokemon's moves
@export var mimic: Mimic

@export_group("Other")
@export var prompt_extra: PromptAsk
##SlotAsk for any extra effects
@export var ask_extra: SlotAsk
##Do extra effect for extra ask
@export var extra_effect: EffectCall

func play_effect(fundies: Fundies, attacking_targets: Array[PokeSlot], defender_targets: Array[PokeSlot]):
	var default_order = [condition, buff, card_disrupt, disable, 
	 energy_movement, dmgManip, search, swap, draw_ammount, alleviate, mimic, extra_effect]
	#var enum_dict: Dictionary = {effect_types.CONDITION:condition, effect_types.BUFF:buff,
	 #effect_types.DISRUPT:card_disrupt, effect_types.DISABLE:disable,
	 #effect_types.ENMOV:energy_movement, effect_types.DMGMANIP: dmgManip,
	 #effect_types.SEARCH: search, effect_types.SWAP:swap, effect_types.DRAW:draw_ammount,
	 #effect_types.ALLEVIATE:alleviate, effect_types.MIMIC:mimic}
	
	print("PLaying effect ", resource_name)
	if order.size() > 0:
		for effect in order:
			if default_order[effect]:
				print("PLAYING ", effect)
				default_order[effect].play_effect(fundies, attacking_targets, defender_targets)
	
	else:
		for effect in default_order:
			if effect:
				effect.play_effect(fundies, attacking_targets, defender_targets)
