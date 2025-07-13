extends ColorRect

@onready var instructions: RichTextLabel = %Instructions
@onready var yes_button: Button = %Yes
@onready var no_button: Button = %No

func load_answers(ask: String, yes: String, no: String):
	instructions.clear()
	instructions.append_text(ask)
	yes_button.text = yes
	no_button.text = no
	
	var prompt_tween: Tween = get_tree().create_tween()
	prompt_tween.tween_property(self, "modulate", Color.WHITE, .05)

func _on_yes_pressed() -> void:
	SignalBus.prompt_answered.emit(true)
	fade()

func _on_no_pressed() -> void:
	SignalBus.prompt_answered.emit(false)
	fade()

func fade():
	var prompt_tween: Tween = get_tree().create_tween()
	prompt_tween.tween_property(self, "modulate", Color.TRANSPARENT, .05)
	await prompt_tween.finished
	queue_free()
