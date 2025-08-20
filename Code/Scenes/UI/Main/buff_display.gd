extends Control

var change_array: Array[SlotChange]
var index: int

func _ready() -> void:
	hide()

func set_buffs(buffs: Array[SlotChange]) -> void:
	show()
	change_array = buffs
	
	if change_array.size() > 1:
		$Timer.start()
	elif change_array.size() == 1:
		$Timer.stop()
		%Buffs.display_change(change_array[0])
	else:
		$Timer.stop()
		hide()

func _on_timer_timeout() -> void:
	index = (index+1) % buff_array.size()
	var buff: Buff = buff_array[index]
	
	$Buffs.display_buff(buff)
