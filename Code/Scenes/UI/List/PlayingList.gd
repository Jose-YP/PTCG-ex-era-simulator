@icon("res://Art/ProjectSpecific/list(1).png")
extends Control
class_name PlayingList

#--------------------------------------
#region VARIABLES
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
var home: bool = true

#endregion
#--------------------------------------

#--------------------------------------
#region INITALIZATION
func _ready():
	match stack_act:
		Constants.STACK_ACT.PLAY: instruction_text = "Choose which allowed cards to play"
		Constants.STACK_ACT.TUTOR:
			%Close_Button.hide()
			instruction_text = "Choose which allowed cards to add"
		Constants.STACK_ACT.DISCARD:
			%Close_Button.hide()
			instruction_text = "Choose which allowed cards to discard"
		Constants.STACK_ACT.LOOK: instruction_text = "Only allowed to check cards"
		_: printerr(stack_act, " not apart of stack act enum")
	match stack:
		Constants.STACKS.HAND: display_text = "HAND"
		Constants.STACKS.DECK: display_text = "DECK"
		Constants.STACKS.DISCARD: display_text = "DISCARD"
		Constants.STACKS.PRIZE: display_text = "PRIZE"
		Constants.STACKS.PLAY: display_text = "HAND"
		Constants.STACKS.NONE: pass
		_: printerr(stack, " not apart of stack enum")
	
	%Header.set_up(display_text)
	%IdentifierPanel.set_up(instruction_text)
	%ScrollBox.set_items()

#func set_items():
	##print(list, list_item)
	#for item in list:
		#var making = list_item.instantiate()
		#making.card = item
		#making.parent = self
		#%CardList.add_child(making)
		#is_allowed(making)
	#
	#items = %CardList.get_children()
	#if stack_act != Constants.STACK_ACT.PLAY and stack_act != Constants.STACK_ACT.LOOK:
		#sort_items()
#
#func refresh_allowance():
	#items = %CardList.get_children()
	#
	#for item in items:
		#is_allowed(item)
#
#func is_allowed(button: Button) -> void:
	##print("List checking if ", button.card.name, " is allowed ", list[button.card])
	#button.stack_act = stack_act
	#match stack_act:
		#Constants.STACK_ACT.PLAY:
			#var whitelisted: bool = white_list.has(button.card.name)
			#var blacklisted: bool = black_list.has(button.card.name)
			#
			#if (list[button.card] or whitelisted) and not blacklisted and get_parent().can_be_played(button.card):
				#button.allow(allowed_as)
			#else: button.not_allowed()
		#Constants.STACK_ACT.TUTOR:
			#if tutor_component.readied:
				#if tutor_component.list_allowed(button.card) and not button.card.name in black_list:
					#button.allow_move_to(stack_act)
				#else: button.not_allowed()
			#else:
				#if all_lists.any(func(loc_list): return loc_list[button.card]):
					#button.allow_move_to(stack_act)
				#else: 
					#button.not_allowed()
			#
		#_:
			#if list[button.card]:
				#button.allow_move_to(stack_act)
#
##endregion
##--------------------------------------
#
##--------------------------------------
##region ITEM MANAGEMENT
#func reset_items():
	#for item in items:
		#item.queue_free()
	#
	#items = %CardList.get_children()
#
#func remove_item(card: Base_Card):
	#for item in %CardList.get_children():
		#if item.card == card:
			#item.queue_free()
#
#func add_item(card: Base_Card):
	#var making = list_item.instantiate()
	#making.card = card
	#making.parent = self
	#%CardList.add_child(making)
	#is_allowed(making)
#
#func sort_items():
	#Conversions.all_lists = all_lists
	#items = %CardList.get_children()
	#items.sort_custom(Conversions.default_card_sort)
	#for i in range(items.size()):
		#%CardList.move_child(items[i], i)
	#
	#pass
##endregion
##--------------------------------------

#--------------------------------------
#region SIGNALS
func _on_resources_show_list(message: String, looking_at: String, using: Array[Base_Card]):
	%ScrollBox.reset_items()
	
	%Identifier.clear()
	%Instructions.clear()
	%Identifier.append_text(str("[center]", looking_at))
	%Instructions.append_text(str("[center]",message))
	
	for card in using:
		list[card] = true
	%ScrollBox.set_items()
	
	show()

func connect_display():
	display.tree_exited.connect(on_display_freed)

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

#endregion
#--------------------------------------


func _on_movable_pressed() -> void:
	if options:
		Globals.control_disapear(options, options.timing, options.old_position)
