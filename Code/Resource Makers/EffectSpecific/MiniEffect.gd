@icon("res://Art/ProjectSpecific/beauty.png")
extends Resource
class_name MiniEffect

##Determine the order in which the effects are called.
##It's best to fill this in, if you don't want the default enum order
@export var order: Array[Consts.EFFECTS]
##Add a condition
@export var condition: Condition
##Move current energy in play
@export var energy_movement: EnMov
##Move/Add damage counters around slots and stacks
@export var dmgManip: DamageManip
##Swap the active pokemon
@export var swap: PokeSwap
##Mimic other pokemon's moves
@export var mimic: Mimic

signal finished

var went_back: bool = false
var replace_num: int = -1

#These are params since the indivdual call knows best which is what
func play_effect(reversable: bool = false) -> void:
	var default_order = [condition, energy_movement, dmgManip, swap, mimic]
	
	went_back = false
	if reversable: SignalBus.went_back.connect(just_reversed)
	
	print("Playing effect ", resource_name)
	
	if order.size() > 0:
		for effect in order:
			if went_back: return
			if default_order[effect]:
				await handle_component(default_order[effect], reversable)
	
	else:
		for effect in default_order:
			if went_back: return
			if effect: await handle_component(effect, reversable)
	
	if reversable: SignalBus.went_back.disconnect(just_reversed)
	finished.emit()

func handle_component(comp, reversable: bool = false):
	await comp.play_effect(reversable, replace_num)
	print("FINISHED")

func just_reversed():
	went_back = true
	SignalBus.went_back.disconnect(just_reversed)

func has_effect_type(comps: Array[String]):
	var default_order: Array[Object] = [condition, energy_movement, dmgManip, swap, mimic]
	
	for comp in comps:
		for current_comps in default_order:
			if current_comps and current_comps.get_script().get_global_name() == comp:
				return true
	
	return false
