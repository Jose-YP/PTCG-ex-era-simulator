extends Control

@export var list_item: PackedScene
@export var list: Array[Base_Card]

var items: Array[Node] = []
var display_text: String = ""
var cursor: TextureRect

func reset_items():
	for item in items:
		item.queue_free()
	
	if cursor:
		cursor.point_options.clear()
		cursor.queue_free()

func set_items(can_select):
	for item in list:
		var making = list_item.instantiate()
		making.card = item
		%CardList.add_child(making)
		
	
	items = %CardList.get_children()
	
	if can_select:
		cursor = Constants.cursor.instantiate()
		cursor.pointing_at = items[0]
		print(items, cursor.point_options)
		cursor.point_options.append(items)
		
		add_child(cursor)
		cursor.moving = true
		cursor.set_arrow_position()

func _on_resources_show_list(can_select: bool,
 message: String, looking_at: String, using: Array[Base_Card]):
	reset_items()
	
	%Identifier.clear()
	%Instructions.clear()
	%Identifier.append_text(str("[center]", looking_at))
	%Instructions.append_text(str("[center]",message))
	
	list = using
	set_items(can_select)
	
	show()
