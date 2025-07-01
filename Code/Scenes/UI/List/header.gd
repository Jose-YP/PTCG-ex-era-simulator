extends HBoxContainer

@export var closable: bool = false
##Which node will this component drag around?
@export var dragging_node: Control
##If this is filled, it will use this node's position as the offset
@export var based_on: Control
@export var offset: Vector2 = Vector2.ZERO
@export var shrinkNodes: Array[Control]
@export var hideNodes: Array[Control]

@onready var movable: Draggable_Control = $IdentifierPanel/Movable
@onready var identifier: RichTextLabel = %Identifier
@onready var minimize_button: Minimize_Button = %MinimizeButton

func _ready() -> void:
	movable.dragging_node = dragging_node
	movable.based_on = based_on
	movable.offset = offset
	
	minimize_button.shrinkNodes = shrinkNodes
	minimize_button.hideNodes = hideNodes
	minimize_button.set_up()
	
	if closable:
		%Close_Button.show()

func setup(txt: String):
	identifier.append_text(txt)
	
	if txt == "":
		hide()

func _on_movable_pressed() -> void:
	if dragging_node.options:
		Globals.control_disapear(dragging_node.options, .1, dragging_node.options.old_position)

func _on_close_button_pressed() -> void:
	owner.queue_free()
