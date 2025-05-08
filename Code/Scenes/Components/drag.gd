extends Node
class_name Draggable
#This node will be used for nodes that can drag and srop freely, do not use for slots

signal started(event_position)
signal ended

func object_held_down(event: InputEvent, node_pressed: bool = true):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and node_pressed:
			print(event.position)
			started.emit(event.position)
		else:
			print('end')
			ended.emit()
	else:
		print(node_pressed)
		#print(event is InputEventMouseButton)
		#if event is InputEventMouseButton:
			#print(event.button_index == MOUSE_BUTTON_LEFT)
	
