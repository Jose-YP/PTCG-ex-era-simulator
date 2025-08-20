@icon("res://Art/ProjectSpecific/disabled.png")
extends SlotChange
class_name Disable

#@export_group("Disable")
@export var side: Consts.SIDES = Consts.SIDES.DEFENDING
@export var slot: Consts.SLOTS = Consts.SLOTS.ALL
@export var no_weakness: bool = false
@export var no_resistance: bool = false
@export var instead_of_damage: bool = false
@export var do_nothing: bool = false
##Can - Change nothing on the target's attacking ability
##[br]Flip - Target must now win a coinflip to attack
##[br]Can't - Target cannot attack
@export_enum("Can", "Flip", "Can't") var attack: int = 0
@export_enum("Can", "Flip", "Can't") var power: int = 0
@export_subgroup("Retreat")
##-1 means forever, otherwise it's turn duration
@export var retreat_duration: int = 1
@export var disable_retreat: bool = false

signal finished

func play_effect(reversable: bool = false, replace_num: int = -1) -> void:
	print("PLAY DISABLE")
	
	finished.emit()
