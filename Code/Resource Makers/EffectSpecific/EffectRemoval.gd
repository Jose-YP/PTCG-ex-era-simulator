extends Resource
class_name EffectRemoval

#Pokemon
##Use this for effects that are otherwise indefinite
@export_enum("Buff", "Disable", "Override", "TypeChange") var comp: int = 0
@export var must_be: Resource
