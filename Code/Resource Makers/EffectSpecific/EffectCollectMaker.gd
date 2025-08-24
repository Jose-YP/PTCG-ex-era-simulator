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
			await success.play_effect()
			return
		if not result and fail:
			SignalBus.slot_change_failed.emit(success.get_slot_change())
			await fail.play_effect()
			return
	
	elif success:
		await success.play_effect()
		return
	
	elif fail:
		await fail.play_effect()
		return
	print(success.get_slot_change())
	SignalBus.slot_change_failed.emit(success.get_slot_change())

func shared_collect_play(result: bool) -> void:
	if prompt_carry_over:
		if result and success:
			await success.play_effect()
			return
		if not result and fail:
			await fail.play_effect()
			return
	
	else:
		if success:
			await success.play_effect()
			return
		if fail:
			await fail.play_effect()
			return
	
	emit_slot_change_fail()

func emit_slot_change_fail():
	SignalBus.slot_change_failed.emit(success.get_slot_change())
