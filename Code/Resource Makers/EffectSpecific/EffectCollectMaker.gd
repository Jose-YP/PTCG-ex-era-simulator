@icon("res://Art/Energy/48px-Colorless-attack.png")
extends Resource
class_name EffectCollect

@export var prompt: PromptAsk
@export var success: EffectCall
@export var fail: EffectCall

var prompt_carry_over: bool
