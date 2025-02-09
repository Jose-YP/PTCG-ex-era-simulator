extends Resource
class_name CoinFlip

@export var heads: bool = true
@export var const_flip_times: int = 1
@export_enum("None", "PEnergy", "OEnergy") var varying_flip_times: int = 0
@export var until: bool = false
#@export var effect_array: Dictionary{int: Effect}
