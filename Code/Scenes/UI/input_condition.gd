extends Control
class_name InputCondition

var selected: Node

signal finished(use: String)

func _ready() -> void:
	%Header.setup("[center]CONDITION INPUT")
	
	for node in %Conditions.get_children():
		var button: Button = node.get_child(0) as Button
		button.pressed.connect(select_conditition.bind(node))

func select_conditition(node: Node):
	if selected:
		(selected.get_child(0) as Button).button_pressed = false
		selected = node
		(selected.get_child(0) as Button).button_pressed = true
	else:
		selected = node
	
	%Confirm.disabled = not selected

func _on_confirm_pressed():
	finished.emit(selected.name)
