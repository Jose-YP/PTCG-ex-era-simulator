@icon("res://Art/ProjectSpecific/list(1).png")
extends Control
class_name PlayingList

#--------------------------------------
#region VARIABLES
@export var debug: bool = false
@export var list_item: PackedScene
@export var all_lists: Array[Dictionary]
@export var list: Dictionary[Base_Card, bool]
#For cards that can be played multiple ways
@export_flags("Basic", "Evolution", "Item",
"Supporter","Stadium", "Tool", "TM", "RSM", "Fossil",
 "Energy") var allowed_as: int = 1
@export_enum("Play", "Tutor", "Discard", "Look") var interaction: String = "Play"
@export_enum("Hand", "Deck", "Discard", "Prize") var stack: String = "Hand"

@onready var identifier: RichTextLabel = %Identifier
@onready var instructions: RichTextLabel = %Instructions
@onready var old_size: Vector2 = size

var items: Array[Node] = []
var display_text: String = ""
var instruction_text: String = ""
var black_list: Array[String] = []
var white_list: Array[String] = []
var old_posiiton: Vector2
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
	
	set_items()

func set_items():
	print(list)
	for item in list:
		var making = list_item.instantiate()
		making.card = item
		making.parent = self
		%CardList.add_child(making)
		is_allowed(making)
	
	items = %CardList.get_children()

func is_allowed(button: Button) -> void:
	print("List checking if ", button.card.name, " is allowed ", list[button.card])
	button.interaction = interaction
	match interaction:
		"Play":
			var whitelisted: bool = white_list.find(button.card.name) != -1
			var blacklisted: bool = black_list.find(button.card.name) != -1
			#print(button.card_flags & allowed)
			if (list[button.card] or whitelisted) and not blacklisted:
				button.allow(allowed_as)
			else: button.not_allowed()
		_:
			if list[button.card]:
				button.allow_move_to(interaction)
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
	disapear_tween.tween_property(self, "global_position", old_posiiton, .1)
	
	await disapear_tween.finished
	
	queue_free()

func _on_minimize_button_pressed() -> void:
	size = %Header.size if %MinimizeButton.minimized else old_size
	print(%Header.size if %MinimizeButton.minimized else old_size, %MinimizeButton.minimized )
