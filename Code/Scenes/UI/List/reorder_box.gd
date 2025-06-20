extends Control

@export var list: Array[Base_Card]
@export var reorder_item: PackedScene

var location: Constants.STACKS
var placement: Placement
var reordering: Node

func _ready():
	_set_up()

func _process(delta: float) -> void:
	if reordering:
		var current_pos: Vector2 = reordering.reorder_button.global_position
		var item_list: Array[Node] = %ItemList.get_children()
		prints(reordering.index,
		clamp(reordering.index - 2, 0, item_list.size()), 
		clamp(reordering.index, 0, item_list.size()))
		var above: Node = item_list[clamp(reordering.index - 2, 0, item_list.size())]
		var below: Node = item_list[clamp(reordering.index, 0, item_list.size() - 1)]
		printt()
		if reordering.index != 1 and above.global_position.y > current_pos.y:
			swap_nodes(above, reordering)
		
		elif reordering.index != item_list.size() and below.global_position.y < current_pos.y:
			swap_nodes(reordering, below)

func _set_up():
	for i in range(list.size()):
		var making: PanelContainer = reorder_item.instantiate()
		%ItemList.add_child(making)
		making.card = list[i]
		making.index = i + 1
		making.check_reorder.connect(start_reorder)
		making.drop_reorder.connect(place_node)

func start_reorder(button: PanelContainer):
	reordering = button

func place_node():
	#reordering.size = reordering.reorder_button.size
	reordering = null

#Swap the nodes considered top and bottom from eachother
func swap_nodes(top: Node, bottom: Node):
	print("HUH?")
	%ItemList.move_child(top, top.index)
	top.index = clamp(top.index + 1, 1, %ItemList.get_child_count())
	bottom.index = clamp(bottom.index - 1, 1, %ItemList.get_child_count())

func _on_confirm_pressed() -> void:
	var card_list: Array[Base_Card]
	for item in $%ItemList.get_children():
		card_list.append(item.card)
		print(item.card.name)
	
	SignalBus.reorder_cards.emit(card_list, location)
