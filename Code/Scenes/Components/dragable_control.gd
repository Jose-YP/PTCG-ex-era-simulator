@icon("res://Art/ExpansionIcons/40px-SetSymbolUnseen_Forces.png")
extends Button

@onready var drag_component = $Drag as Draggable

@export var dragging_node: Control

var drag_position: Vector2

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	var new_pos: Vector2 = get_global_mouse_position() - drag_position
	
	new_pos.x = clampf(new_pos.x, -size.x/2, get_viewport().size.x - size.x/2)
	new_pos.y = clampf(new_pos.y, -get_viewport().size.y / 2, get_viewport().size.y / 2)
	
	dragging_node.position = new_pos

func _on_drag_ended() -> void:
	set_process(false)

func _on_drag_started(event_position: Variant) -> void:
	drag_position = event_position
	set_process(true)

func _on_gui_input(event: InputEvent) -> void:
	drag_component.object_held_down(event)
