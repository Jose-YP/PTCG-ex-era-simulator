extends Control

@export var side_version: bool = false

var change_array: Array[SlotChange]
var index: int

func _ready() -> void:
	set_vis(false)
	if side_version:
		custom_minimum_size = Vector2(32,32)
		%Panel.size = Vector2(32,32)

func set_vis(vis: bool):
	if side_version:
		modulate = Color.WHITE if vis else Color.TRANSPARENT
	else:
		visible = vis
	
	if vis:
		get_parent().show()

func set_changes(changes: Array[SlotChange]) -> void:
	set_vis(true)
	change_array = changes
	
	if change_array.size() > 1:
		$Timer.start()
	elif change_array.size() == 1:
		$Timer.stop()
		%Changes.display_change(change_array[0])
	else:
		$Timer.stop()
		set_vis(false)

func _on_timer_timeout() -> void:
	index = (index+1) % change_array.size()
	var change: SlotChange = change_array[index]
	
	%Changes.display_change(change)
