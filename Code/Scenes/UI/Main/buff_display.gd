extends Control

@export var side_version: bool = false

var change_array: Array[SlotChange]
var index: int

func _ready() -> void:
	modulate = Color.TRANSPARENT
	if side_version:
		custom_minimum_size = Vector2(32,32)
		%Panel.size = Vector2(32,32)

func set_changes(changes: Array[SlotChange]) -> void:
	modulate = Color.WHITE
	change_array = changes
	
	if change_array.size() > 1:
		$Timer.start()
	elif change_array.size() == 1:
		$Timer.stop()
		%Changes.display_change(change_array[0])
	else:
		$Timer.stop()
		modulate = Color.TRANSPARENT

func _on_timer_timeout() -> void:
	index = (index+1) % change_array.size()
	var change: SlotChange = change_array[index]
	
	%Changes.display_change(change)
