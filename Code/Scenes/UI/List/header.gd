extends HBoxContainer

@export_category("DraggingNode Exports")
##Which node will this component drag around?
@export var dragging_node: Control
##If this is filled, it will use this node's position as the offset
@export var based_on: Control
@export var offset: Vector2 = Vector2.ZERO
@export_category("MinimizeNode Exports")
@export var shrinkNodes: Array[Control]
@export var hideNodes: Array[Control]

@onready var identifier: RichTextLabel = %Identifier
@onready var movable: Draggable_Control = $IdentifierPanel/Movable
@onready var minimize_button: Minimize_Button = %MinimizeButton
@onready var close_button: Close_Button = %Close_Button

func _ready() -> void:
	movable.dragging_node = dragging_node
	movable.based_on = based_on
	movable.offset = offset
	
	minimize_button.shrinkNodes = shrinkNodes
	minimize_button.hideNodes = hideNodes

func set_up(string: String):
	identifier.clear()
	identifier.append_text(string)
