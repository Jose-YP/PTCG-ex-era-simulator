extends Resource
class_name EffectCall


enum effect_types{CONDITION, BUFF, DISRUPT, DISABLE, 
ENMOV, DMGMANIP, SEARCH, SWAP, DRAW, ALLEVIATE, MIMIC, OTHER}

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
##SlotAsk for any extra effects
@export var ask_extra: SlotAsk
##Do extra effect for extra ask
@export var extra_effect: EffectCall

func play_effect(fundies: Fundies):
	var default_order = [condition, buff, card_disrupt, disable, 
energy_movement, dmgManip, search, swap, draw_ammount, alleviate, mimic, extra_effect]
	if order.size() > 0:
		for effect in order:
			if default_order[effect]:
				default_order[effect].play_effect(fundies)
	
	else:
		for effect in default_order:
			effect.play_effect(fundies)
