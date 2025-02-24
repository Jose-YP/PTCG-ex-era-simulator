extends Resource
class_name Buff

#@export_group("Buff & Debuff")
##Who recieves the buff?
@export_enum("PlayerAll", "OpponentAll", "Self",
"Defender", "Both Active", "Both Defending") var buff_target: int = 0
##-1 means forever, otherwise how many turns is this active
@export var duration: int = 1
##How much more damage to the active spot?
@export_range(-120, 120, 10) var attack_damage: int = 0
##How much less damage should be taken from opponent
@export_range(-120, 120, 10) var defense: int = 0
##Is it applied before or after weak/res
@export var after_weak_res: bool = true
##Stop any effects calls if this is true
@export var immune_to_effects: bool = false
##Immune to regular & bench damage [NOT DAMAGE MANIP EFFECT CALLS]
@export var immune_to_damage: bool = false
