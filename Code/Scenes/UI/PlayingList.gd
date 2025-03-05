extends Control

@export var debug: bool = false
@export var list_item: PackedScene
@export var list: Array[Base_Card]
@export_flags("Basic", "Evolution", "Item",
"Supporter","Stadium", "Tool", "TM", "RSM", "Fossil",
 "Energy") var allowed: int = 1

@onready var identifier: RichTextLabel = %Identifier
@onready var instructions: RichTextLabel = %Instructions

var items: Array[Node] = []
var display_text: String = ""
var instruction_text: String = ""
var black_list: Array[String] = []
var white_list: Array[String] = []

#--------------------------------------
#region CARD DISPLAY
func _ready():
	identifier.append_text(display_text)
	instructions.append_text(instruction_text)
	
	set_items()

func set_items():
	print(list)
	for item in list:
		var making = list_item.instantiate()
		making.card = item
		%CardList.add_child(making)
		is_allowed(making)
	
	items = %CardList.get_children()

func is_allowed(button: Button) -> void:
	var whitelisted: bool = white_list.find(button.card.name) != -1
	var blacklisted: bool = black_list.find(button.card.name) != -1
	#print(button.card_flags & allowed)
	if (button.card_flags & allowed or whitelisted) and not blacklisted:
		button.allow()
	else:
		button.not_allowed()
#endregion
#--------------------------------------

func reset_items():
	for item in items:
		item.queue_free()

func _on_resources_show_list(message: String, looking_at: String, using: Array[Base_Card]):
	reset_items()
	
	%Identifier.clear()
	%Instructions.clear()
	%Identifier.append_text(str("[center]", looking_at))
	%Instructions.append_text(str("[center]",message))
	
	list = using
	set_items()
	
	show()
