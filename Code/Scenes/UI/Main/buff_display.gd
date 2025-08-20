extends Control

var change_array: Array[SlotChange]
var index: int

func _ready() -> void:
	hide()

func set_changes(changes: Array[SlotChange]) -> void:
	show()
	
	change_array = changes
	
	if change_array.size() > 1:
		$Timer.start()
	elif change_array.size() == 1:
		$Timer.stop()
		%Changes.display_change(change_array[0])
	else:
		$Timer.stop()
		hide()

func _on_timer_timeout() -> void:
	index = (index+1) % change_array.size()
	var change: SlotChange = change_array[index]
	
	%Changes.display_change(change)
