extends Resource
class_name Energy

@export_group("Properties")
@export_enum("Basic Energy", "Special Energy") var considered: String = "Special Energy"

@export_group("Prerequisites")
@export var asks: Ask
@export var fail_provide: bool = false
@export var fail_effect: EffectCall
@export var success_effect: EffectCall
@export var always_effect: EffectCall

@export_group("Duration")
@export var turns: int = -1 #-1 means forever

@export_group("Provides")
@export var number: int = 1
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var type: int = 1
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var fail_type: int = 1
