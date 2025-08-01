extends Resource
class_name PokeBody

@export var when_active: bool = false
@export var name: String = ""
@export_multiline var description: String = ""

@export_group("Prerequisites")
@export var prompt: PromptAsk
@export var ask: SlotAsk
@export var affected_by_condition: bool = true
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var attatched_energy: int = 0
@export var energy_ammount: int = 1

@export_group("Action")
@export var effect: EffectCall
