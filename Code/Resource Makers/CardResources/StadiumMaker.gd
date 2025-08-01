extends Resource
class_name Stadium

@export_enum("Anytime", "Between Turns") var when_to_check: int = 0
##Who should the stadium activate on
@export var determine_ask: SlotAsk
##This effect is a passive that applies depending on ask
@export var stadium_effect: EffectCall
##Does the stadium operate on demand?
@export var prompt: PromptAsk
##This effect needs to be explicitly called upon
@export var activate_effect: EffectCall
@export_group("Rule Changes")
##-1 means ignore effect, otherwise bench size changes to ammount specified
@export var bench_size: int = -1
