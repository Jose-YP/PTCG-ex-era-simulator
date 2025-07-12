@icon("res://Art/ProjectSpecific/beauty.png")
extends Resource
class_name EffectCall

enum effect_types{CONDITION, BUFF, DISRUPT, DISABLE, 
ENMOV, DMGMANIP, SEARCH, SWAP, DRAW, ALLEVIATE, MIMIC, OTHER}

@export var either_or: bool = false
##Determine the order in which the effects are called.
##It's best to fill this in, if you don't want the default enum order
@export var order: Array[effect_types]
@export_group("Components")
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
##What rules should be changed?
@export var override: OverRide

@export_group("Other")
@export var prompt_extra: PromptAsk
##SlotAsk for any extra effects
@export var ask_extra: SlotAsk
##Do extra effect for extra ask
@export var extra_effect: EffectCall

signal finished
signal reversed

var went_back: bool = false

#These are params since the indivdual call knows best which is what
func play_effect(reversable: bool = false):
	var default_order = [condition, buff, card_disrupt, disable, 
	 energy_movement, dmgManip, search, swap, draw_ammount, alleviate, mimic, extra_effect]
	#var enum_dict: Dictionary = {effect_types.CONDITION:condition, effect_types.BUFF:buff,
	 #effect_types.DISRUPT:card_disrupt, effect_types.DISABLE:disable,
	 #effect_types.ENMOV:energy_movement, effect_types.DMGMANIP: dmgManip,
	 #effect_types.SEARCH: search, effect_types.SWAP:swap, effect_types.DRAW:draw_ammount,
	 #effect_types.ALLEVIATE:alleviate, effect_types.MIMIC:mimic}
	
	went_back = false
	if reversable: SignalBus.went_back.connect(just_reversed)
	
	print("PLaying effect ", resource_name)
	#fundies.record_source_target(home, atk_trg, def_trg)
	if order.size() > 0:
		for effect in order:
			if went_back:
				print()
				return
			
			if default_order[effect]:
				print("PLAYING ", effect)
				await handle_component(default_order[effect], reversable)
	
	else:
		for effect in default_order:
			if went_back:
				print()
				return
			
			if effect:
				await handle_component(effect, reversable)
	
	finished.emit()

func handle_component(comp, reversable: bool = false):
	if reversable:
		comp.reversed.connect(just_reversed)
	
	await comp.play_effect(reversable)
	
	if reversable:
		comp.reversed.disconnect(just_reversed)

func just_reversed():
	went_back = true
	SignalBus.went_back.disconnect(just_reversed)
	reversed.emit()
