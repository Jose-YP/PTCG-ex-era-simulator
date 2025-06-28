extends Resource
class_name DamageManip

#@export_group("Counters")
##Add Counters if this is false
@export var remove: bool = true
##-1 means remove/add max ammount
@export_range(-1,20) var how_many: int = 1
##If this is true, the player must choose between the choices for how_many times.
@export var choose_from: bool = false
@export var include_target: bool = true
##Who will get the counter manipulation
@export var side: Constants.SIDES = Constants.SIDES.ATTACKING
@export var slot: Constants.SLOTS = Constants.SLOTS.TARGET
##Determines how many will be added/removed based on the Counter
@export_group("Counter")
@export var plus: bool = false
@export var counter: Counter

signal finished

func play_effect():
	print("PLAY DAMAGE MANIPULATION")
	
	finished.emit()
