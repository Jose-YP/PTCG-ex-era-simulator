extends Control

var buff_array: Array[Buff]
var index: int

func _ready() -> void:
	hide()

func set_buffs(buffs: Array[Buff]) -> void:
	show()
	buff_array = buffs
	
	if buff_array.size() > 1:
		$Timer.start()
	elif buff_array.size() == 1:
		$Timer.stop()
		$Buffs.display_buff(buff_array[0])
	else:
		$Timer.stop()
		hide()

func _on_timer_timeout() -> void:
	index = (index+1) % buff_array.size()
	var buff: Buff = buff_array[index]
	
	$Buffs.display_buff(buff)
