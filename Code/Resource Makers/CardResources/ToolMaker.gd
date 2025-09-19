extends Resource
class_name ToolCard

@export_enum("Anytime", "Between Turns") var when_to_check: int = 0
@export var prompt_ask: PromptAsk
##Is there anything that needs to happen for the tool to activate?
@export var occurance: Occurance
##If this is [code]true[/code] then [member tool_effect] will not trigger remove after
##[member occurance] Prompt ask and occurance will remove the tool
@export var seperate_effect: bool
@export var tool_effect: Array[EffectCollect]
##remove tool after it's effect is used
@export var remove_after: bool = true
##-1 means it lasts forever, otherwise it last for this ammount of turns
@export var duration: int = -1
