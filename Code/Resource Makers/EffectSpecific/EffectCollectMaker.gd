@icon("res://Art/Energy/48px-Colorless-attack.png")
extends Resource
class_name EffectCollect

@export var prompt: PromptAsk
@export var success: EffectCall
@export var fail: EffectCall

var prompt_carry_over: bool

func effect_collect_play() -> void:
	if prompt:
		var result: bool = await prompt.generic_check()
		if prompt.has_coinflip():
			await SignalBus.finished_coinflip
		
		if result and success:
			success.play_effect()
			return
		elif fail:
			SignalBus.slot_change_failed.emit(success.get_slot_change())
			fail.play_effect()
			return
	
	elif success:
		success.play_effect()
		return
	
	elif fail:
		fail.play_effect()
		return
	print(success.get_slot_change())
	SignalBus.slot_change_failed.emit(success.get_slot_change())

func emit_slot_change_fail():
	SignalBus.slot_change_failed.emit(success.get_slot_change())
