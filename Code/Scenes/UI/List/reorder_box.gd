@icon("res://Art/ProjectSpecific/list(1).png")
extends Control

@export var stack_act: Constants.STACK_ACT = Constants.STACK_ACT.REORDER
@export var stack: Constants.STACKS = Constants.STACKS.HAND
@export var list_item: PackedScene

@onready var title: RichTextLabel = %Title
@onready var req_text: RichTextLabel = %ReqText

var all_lists: Array[Dictionary]
var current_list: Dictionary[Array, bool]
var items: Array[Node]
var instruction_text: String
var display_text

func _ready():
	title.append_text(display_text)
	req_text.append_text(instruction_text)
	
	set_items()

func set_items():
	for item in current_list:
		var making = list_item.instantiate()
		making.card = item
		making.parent = self
		making.reorder = true
		%CardList.add_child(making)
	
	items = %CardList.get_children()
