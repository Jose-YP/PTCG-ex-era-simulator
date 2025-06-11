@tool
@icon("res://Art/ExpansionIcons/SetSymbolTeam_Magma_vs_Team_Aqua.png")
extends Button
class_name Minimize_Button

@export var shrinkNodes: Array[Control]
@export var hideNodes: Array[Control]

var original_sizes: Dictionary[Control,Vector2]
var minimized: bool = false

func _get_configuration_warnings() -> PackedStringArray:
	if shrinkNodes.size() == 0:
		return ["No nodes will get minimized by minimize"]
	elif hideNodes.size() == 0:
		return ["No nodes will be hidden by minimize"]
	else:
		return []

func _ready() -> void:
	for node in shrinkNodes:
		original_sizes[node] = node.custom_minimum_size

func _on_pressed() -> void:
	if minimized:
		minimized = false
		await opening_animation()
		disabled = false
	else:
		minimized = true
		await closing_animation()
		disabled = false

func closing_animation() -> void:
	disabled = true
	var closing_tween: Tween = create_tween().set_parallel()
	for node in shrinkNodes:
		closing_tween.tween_property(node, "custom_minimum_size", Vector2.ZERO, .1)
	for node in hideNodes:
		node.hide()
	
	await closing_tween.finished

func opening_animation() -> void:
	disabled = true
	var opening_tween: Tween = create_tween().set_parallel()
	for node in shrinkNodes:
		opening_tween.tween_property(node, "custom_minimum_size", original_sizes[node], .1)
	for node in hideNodes:
		node.show()
