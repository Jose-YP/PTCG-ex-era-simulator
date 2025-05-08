extends Button

@onready var drag_component = $Drag as Draggable

@export var dragging_node: Control

var drag_position: Vector2

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	dragging_node.position = get_global_mouse_position() - size / 2

func _on_drag_ended() -> void:
	set_process(false)

func _on_drag_started(event_position: Variant) -> void:
	drag_position = event_position
	set_process(true)

func _on_gui_input(event: InputEvent) -> void:
	drag_component.object_held_down(event)
