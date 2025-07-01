@icon("res://Art/ProjectSpecific/list(1).png")
extends Control
class_name PlayingList

#--------------------------------------
#region VARIABLES
@export var par: Control
@export var tutor_box: PackedScene
@export var all_lists: Array[Dictionary]
@export var list: Dictionary[Base_Card, bool]
#For cards that can be played multiple ways
@export_flags("Basic", "Evolution", "Item",
"Supporter","Stadium", "Tool", "TM", "RSM", "Fossil",
 "Energy") var allowed_as: int = 1
@export var stack_act: Constants.STACK_ACT = Constants.STACK_ACT.PLAY
@export var stack: Constants.STACKS = Constants.STACKS.HAND

const list_item: PackedScene = preload("res://Scenes/UI/Lists/PlayingListItem_copy.tscn")

var items: Array[Node] = []
var black_list: Array[String] = []
var white_list: Array[String] = []
var display: Node
var options: Node
var on_card: bool = false
var home: bool = true

#endregion
#--------------------------------------

#--------------------------------------
#region INITALIZATION
func set_items():
	stack = par.stack
	stack_act = par.stack_act
	
	for item in list:
		var making = list_item.instantiate()
		making.card = item
		making.parent = self
		%CardList.add_child(making)
		is_allowed(making)
	
	items = %CardList.get_children()
	if stack_act != Constants.STACK_ACT.PLAY and stack_act != Constants.STACK_ACT.LOOK:
		sort_items()

func refresh_allowance():
	items = %CardList.get_children()
	
	for item in items:
		is_allowed(item)

func is_allowed(button: Button) -> void:
	#print("List checking if ", button.card.name, " is allowed ", list[button.card])
	button.stack_act = stack_act
	match stack_act:
		Constants.STACK_ACT.PLAY:
			var whitelisted: bool = white_list.has(button.card.name)
			var blacklisted: bool = black_list.has(button.card.name)
			
			if (list[button.card] or whitelisted) and not blacklisted and Globals.fundies.can_be_played(button.card):
				button.allow(allowed_as)
			else: button.not_allowed()
		Constants.STACK_ACT.TUTOR:
			if par.readied:
				if par.list_allowed(button.card) and not button.card.name in black_list:
					button.allow_move_to(stack_act)
				else: button.not_allowed()
			else:
				if all_lists.any(func(loc_list): return loc_list[button.card]):
					button.allow_move_to(stack_act)
				else: 
					button.not_allowed()
			
		_:
			if list[button.card]:
				button.allow_move_to(stack_act)

#endregion
#--------------------------------------

#--------------------------------------
#region ITEM MANAGEMENT
func reset_items():
	for item in items:
		item.queue_free()
	
	items = %CardList.get_children()

func remove_item(card: Base_Card):
	for item in %CardList.get_children():
		if item.card == card:
			item.queue_free()

func add_item(card: Base_Card):
	var making = list_item.instantiate()
	making.card = card
	making.parent = self
	%CardList.add_child(making)
	is_allowed(making)

func sort_items():
	Conversions.all_lists = all_lists
	items = %CardList.get_children()
	items.sort_custom(Conversions.default_card_sort)
	for i in range(items.size()):
		%CardList.move_child(items[i], i)
	
	pass
#endregion
#--------------------------------------
