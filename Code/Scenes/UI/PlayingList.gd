extends Control

@export var debug: bool = false
@export var list_item: PackedScene
@export var list: Array[Base_Card]
@export_flags("Basic", "Evolution", "Item",
"Supporter", "Energy") var allowed: int = 1

var items: Array[Node] = []
var display_text: String = ""

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
		
	
	items = %CardList.get_children()

func _on_resources_show_list(message: String, looking_at: String, using: Array[Base_Card]):
	reset_items()
	
	%Identifier.clear()
	%Instructions.clear()
	%Identifier.append_text(str("[center]", looking_at))
	%Instructions.append_text(str("[center]",message))
	
	list = using
	set_items()
	
	show()
