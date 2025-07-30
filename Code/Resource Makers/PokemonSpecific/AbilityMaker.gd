extends Resource
class_name Ability

@export_enum("Body", "Power") var category: String = "Body"
@export var name: String = ""
@export_multiline var description: String = ""

@export var affected_by_condition: bool = true
@export var active: bool = false
@export_enum("Passive", "Once per Mon", "Once per turn", "Infinite") var how_often: int = 0
@export var on_occurance: bool = false
@export var prompt: PromptAsk
@export var occurance: Occurance
@export var effect: EffectCall
