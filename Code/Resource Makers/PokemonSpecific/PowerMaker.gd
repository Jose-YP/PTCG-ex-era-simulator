extends Resource
class_name PokePower

@export var name: String = ""
@export_multiline var description: String = ""

@export_group("Prerequisites")
@export var affected_by_condition: bool = true
@export var active: bool = false
@export_enum("Once per Mon", "Once per turn", "Infinite") var how_often: int = 0

@export_group("Action")
@export var target_ask: Ask
@export var effect: EffectCall
