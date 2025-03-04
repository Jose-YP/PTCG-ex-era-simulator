extends Control

@export var debug: bool = false
@export var list_item: PackedScene
@export var list: Array[Base_Card]
@export_flags("Basic", "Evolution", "Item",
"Supporter","Stadium", "Tool", "TM", "RSM", "Fossil",
 "Energy") var allowed: int = 1

var items: Array[Node] = []
var display_text: String = ""
var black_list: Array[String] = []
var white_list: Array[String] = []

func _ready():
	print(debug)
	if debug: set_items()

func reset_items():
	for item in items:
		item.queue_free()

func set_items():
	print(list)
	for item in list:
		var making = list_item.instantiate()
		making.card = item
		%CardList.add_child(making)
		is_allowed(item)
	
	items = %CardList.get_children()

func is_allowed(button) -> void:
	var whitelisted: bool = white_list.find(button.card.name) != -1
	var blacklisted: bool = black_list.find(button.card.name) != -1
	
	if button.card_flags && allowed or whitelisted and not blacklisted:
		button.allow()

func _on_resources_show_list(message: String, looking_at: String, using: Array[Base_Card]):
	reset_items()
	
	%Identifier.clear()
	%Instructions.clear()
	%Identifier.append_text(str("[center]", looking_at))
	%Instructions.append_text(str("[center]",message))
	
	list = using
	set_items()
	
	show()
