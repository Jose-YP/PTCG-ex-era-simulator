extends PanelContainer

@export_category("DraggingNode Exports")
##Which node will this component drag around?
@export var dragging_node: Control
##If this is filled, it will use this node's position as the offset
@export var based_on: Control
@export var offset: Vector2 = Vector2.ZERO
@onready var identifier_panel: PanelContainer = %IdentifierPanel

@onready var movable: Draggable_Control = $Movable
@onready var instructions: RichTextLabel = %Instructions

func _ready() -> void:
	movable.dragging_node = dragging_node
	movable.based_on = based_on
	movable.offset = offset

func set_up(string: String):
	instructions.clear()
	instructions.append_text(string)
	if string == "": hide()
