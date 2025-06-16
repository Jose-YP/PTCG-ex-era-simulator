@icon("res://Art/ProjectSpecific/list(1).png")
extends Control
class_name PlayingList

#--------------------------------------
#region VARIABLES
@export var debug: bool = false
@export var list_item: PackedScene
@export var tutor_box: PackedScene
@export var all_lists: Array[Dictionary]
@export var list: Dictionary[Base_Card, bool]
#For cards that can be played multiple ways
@export_flags("Basic", "Evolution", "Item",
"Supporter","Stadium", "Tool", "TM", "RSM", "Fossil",
 "Energy") var allowed_as: int = 1
@export var stack_act: Constants.STACK_ACT = Constants.STACK_ACT.PLAY
@export var stack: Constants.STACKS = Constants.STACKS.HAND

#@onready var tutor_box: Tutor_Box = %TutorBox
@onready var identifier: RichTextLabel = %Identifier
@onready var instructions: RichTextLabel = %Instructions
@onready var old_size: Vector2 = size
@onready var tutor_component: Node = $TutorComponent

var items: Array[Node] = []
var display_text: String = ""
var instruction_text: String = ""
var black_list: Array[String] = []
var white_list: Array[String] = []
var old_pos: Vector2
var display: Node
var options: Node
var on_card: bool = false

#endregion
#--------------------------------------

#--------------------------------------
#region INITALIZATION
func _ready():
	identifier.append_text(display_text)
	instructions.append_text(instruction_text)
	
	if stack != Constants.STACKS.HAND:
		%Close_Button.hide()
	
	set_items()

func set_items():
	#print(list, list_item)
	for item in list:
		var making = list_item.instantiate()
		making.card = item
		making.parent = self
		%CardList.add_child(making)
		is_allowed(making)
	
	items = %CardList.get_children()
	if stack_act != Constants.STACK_ACT.PLAY:
		sort_items()

func refresh_allowance():
	items = %CardList.get_children()
	
	for item in items:
		is_allowed(item)

func is_allowed(button: Button) -> void:
	print("List checking if ", button.card.name, " is allowed ", list[button.card])
	button.stack_act = stack_act
	match stack_act:
		Constants.STACK_ACT.PLAY:
			var whitelisted: bool = white_list.find(button.card.name) != -1
			var blacklisted: bool = black_list.find(button.card.name) != -1
			#print(button.card_flags & allowed)
			if (list[button.card] or whitelisted) and not blacklisted:
				button.allow(allowed_as)
			else: button.not_allowed()
		Constants.STACK_ACT.TUTOR:
			if tutor_component.readied:
				if tutor_component.list_allowed(button.card):
					button.allow_move_to(stack_act)
				else: button.not_allowed()
			else:
				var result: bool = false
				for loc_list in all_lists:
					result = result or loc_list[button.card]
				if result: button.allow_move_to(stack_act)
				else: button.not_allowed()
			
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
	print(items)
	for i in range(items.size()):
		%CardList.move_child(items[i], i)
	
	pass
#endregion
#--------------------------------------

#--------------------------------------
#region SIGNALS
func _on_resources_show_list(message: String, looking_at: String, using: Array[Base_Card]):
	reset_items()
	
	%Identifier.clear()
	%Instructions.clear()
	%Identifier.append_text(str("[center]", looking_at))
	%Instructions.append_text(str("[center]",message))
	
	for card in using:
		list[card] = true
	set_items()
	
	show()

func connect_display():
	display.tree_exited.connect(on_display_freed)

#func _input(event: InputEvent) -> void:
	##Check if the user is pressing on the card or outside
	#if event.is_action_released("A") and display:
		#if Globals.dragging:
			#Globals.dragging = false
		##If they're not pressing on the card, erase the card
		#else:
			#display.close_button._on_pressed()

func on_display_freed():
	Globals.reset_check()

func disapear():
	var disapear_tween: Tween = get_tree().create_tween().set_parallel()
	
	disapear_tween.tween_property(self, "modulate", Color.TRANSPARENT, .1)
	disapear_tween.tween_property(self, "scale", Vector2(.1,.1), .1)
	disapear_tween.tween_property(self, "global_position", old_pos, .1)
	
	await disapear_tween.finished
	
	queue_free()

func _on_minimize_button_pressed() -> void:
	size = %Header.size if %MinimizeButton.minimized else old_size
	print(%Header.size if %MinimizeButton.minimized else old_size, %MinimizeButton.minimized )
#endregion
#--------------------------------------
