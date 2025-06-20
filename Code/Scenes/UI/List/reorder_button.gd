extends PanelContainer

@export var card: Base_Card
@onready var movable: Draggable_Control = $Movable

var parent: Node
var checking_card: Node
var stack_act: Constants.STACK_ACT
var allowed: bool = false
var from_id: Identifier
var origin: Vector2

func _ready() -> void:
	%Class.clear()
	%Class.append_text(card.get_considered())
	
	%Art.texture = card.image
	%Name.clear()
	%Name.append_text(card.name)
	
	set_name(card.name)

func _on_movable_drag() -> void:
	origin = position
	top_level = true
	focus_entered.emit()
	global_position = get_global_mouse_position()

func _on_movable_drop() -> void:
	top_level = false
	position = origin
	focus_exited.emit()
