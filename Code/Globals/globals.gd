extends Node

#For any node that can bring up the check card display
var checking: bool = false
var dragging: bool = false

signal enter_check
signal exit_check

func checking_card():
	checking = true
	enter_check.emit()

func reset_check():
	checking = false
	exit_check.emit()

func control_disapear(node: Node, timing: float, old_position: Vector2 = Vector2.ZERO):
	var disapear_tween: Tween = get_tree().create_tween().set_parallel()
	
	disapear_tween.tween_property(node, "position", old_position, timing)
	disapear_tween.tween_property(node, "modulate", Color.TRANSPARENT, timing)
	disapear_tween.tween_property(node, "scale", Vector2(.1,.1), timing)
	
	await disapear_tween.finished
	
	node.queue_free()
