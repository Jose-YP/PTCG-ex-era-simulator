extends Button

func _on_pressed() -> void:
	SignalBus.end_turn.emit()
