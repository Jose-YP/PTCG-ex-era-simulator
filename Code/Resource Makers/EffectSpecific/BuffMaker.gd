@icon("res://Art/ProjectSpecific/sword(1).png")
extends Resource
class_name Buff

#@export_group("Buff & Debuff")
##Who recieves the buff?
@export var side: Constants.SIDES = Constants.SIDES.ATTACKING
@export var slot: Constants.SLOTS = Constants.SLOTS.TARGET
##-1 means forever, otherwise how many turns is this active
@export var duration: int = 1
##If against this type of pokemon use these buffs, if null return [code]true
@export var against: SlotAsk
##How much more damage to the active spot?
@export_range(-120, 120, 10) var attack_damage: int = 0
##How much less damage should be taken from opponent
@export_range(-120, 120, 10) var defense: int = 0
##How mucht to add/subtract from a pokemon's retreat cost?
@export_range(-10,6,1) var retreat_change: int = 0
##Is it applied before or after weak/res
@export var after_weak_res: bool = true
##Ignore the resistance of whatever this pokemon attacks next
@export var ignore_res_other: bool = false
##Ignore the pokemon's weakness when taking damage
@export var ignore_weak_self: bool = false
@export_flags("Special Conditions", "Effects", "Damage") var immunities: int = 0
##Ignore any conditions if this is true
@export var immune_to_special_conditions: bool = false
##Stop any effects calls if this is true
@export var immune_to_effects: bool = false
##Immune to regular & bench damage [NOT DAMAGE MANIP EFFECT CALLS]
@export var immune_to_damage: bool = false

signal finished

func play_effect(reversable: bool = false):
	print("PLAY BUFF")
	
	finished.emit()
