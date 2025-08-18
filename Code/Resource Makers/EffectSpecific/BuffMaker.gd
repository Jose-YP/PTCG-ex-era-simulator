@icon("res://Art/ProjectSpecific/sword(1).png")
extends Resource
class_name Buff

@export_multiline var description: String

@export_enum("Slot", "Side") var application: String = "Slot"
@export var stackable: bool = true
##Who recieves the buff?
@export var recieves: SlotAsk
##-1 means forever, otherwise how many turns is this active
@export var duration: int = 1
##If against this type of slot use these buffs, if null return [code]true
@export var against: SlotAsk
##Is it applied before or after weak/res
@export var after_weak_res: bool = true

@export_group("Stat Change")
@export_enum("None","HP", "Attack", "Defense", "Retreat", "Colorless Cost") var modify: String = "HP"
@export_enum("Add", "Subtract", "Multiply", "Replace") var operation: String = "Add"
@export_range(-200, 200, 10) var add_hp: int = 0
##How much more damage to target?
@export_range(-120, 120, 10) var attack: int = 0
##How much less damage should be taken from attacks
@export_range(-120, 120, 10) var defense: int = 0
##How mucht to add/subtract from a pokemon's retreat cost?
@export_range(-10,6,1) var retreat_change: int = 0
@export_subgroup("Attack Cost")
@export_enum("Add", "Subtract", "Replace") var cost_modifier: String = "Add"
@export var attack_cost: AttackCost
@export_subgroup("Comparator")
@export var plus: bool
@export var comparator: Comparator

@export_group("Immunities")
##Ignore any conditions if this is true
@export_flags("Poison","Burn","Paralysis", "Sleep", "Confusion") var condition_immune: int = 0
##Stop any effects calls from attack calls if this is true including dmg manip
@export var attack_effect_immune: bool = false
##Immune to regular & bench damage [NOT DAMAGE MANIP EFFECT CALLS]
@export var damage_immune: bool = false
@export var body_immune: bool = false
@export var power_immune: bool = false
@export var trainer_immune: bool = false
@export_subgroup("Weird Immunities")
@export var odd_immunity: bool = false
@export var even_immunity: bool = false

@export_group("Pierce")
@export var weakness: bool
@export var resistance: bool
@export var effects: bool

@export_group("Specifiers")
@export var attack_names: Array[String]

signal finished

func play_effect(reversable: bool = false, replace_num: int = -1) -> void:
	print("PLAY BUFF")
	
	finished.emit()
