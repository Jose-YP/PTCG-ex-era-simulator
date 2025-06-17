extends Button

@export var card: Base_Card
@export var option_offset: Vector2 = Vector2(30, 100)
@export_flags("Basic", "Evolution", "Item",
"Supporter", "Stadium", "Tool", "TM", "RSM", "Fossil",
 "Energy") var card_flags: int = 0

var parent: Node
var checking_card: Node
var stack_act: Constants.STACK_ACT
var allowed: bool = false
var from_id: Identifier

#--------------------------------------
#region INITALIZATION
func _ready() -> void:
	%Class.clear()
	card_flags = Conversions.get_card_flags(card)
	
	if card_flags & 1 or card_flags & 2: %Class.append_text(card.pokemon_properties.evo_stage)
	elif card_flags & 8: %Class.append_text("Support")
	elif card_flags & 128: %Class.append_text("RSM")
	elif card_flags & 256: %Class.append_text("Fossil")
	elif card_flags & 512: %Class.append_text(card.energy_properties.considered)
	else: %Class.append_text(card.trainer_properties.considered)
	
	%Art.texture = card.image
	%Name.clear()
	%Name.append_text(card.name)
	
	set_name(card.name)

func allow(play_as: int):
	allowed = true
	print(play_as & card_flags, play_as, card_flags)
	card_flags = play_as & card_flags
	disabled = false

func not_allowed():
	allowed = false
	disabled = true

func allow_move_to(destination: Constants.STACKS):
	allowed = true
	disabled = false
	match destination:
		Constants.STACKS.DISCARD: stack_act = Constants.STACK_ACT.DISCARD
		_: stack_act = Constants.STACK_ACT.TUTOR

func is_tutored() -> bool:
	print(parent is PlayingList)
	return not parent is PlayingList

func get_specifc_id():
	pass

#endregion
#--------------------------------------

#--------------------------------------
#region ACTIONS
func show_options() -> Node:
	var option_Display = load("res://Scenes/UI/Lists/item_options_copy.tscn").instantiate()
	print(option_Display, option_Display.get_script(), option_Display.has_method("set"))
	print("LIST\n -----------------------\n",option_Display.get_property_list())
	option_Display.card_flags = card_flags
	option_Display.global_position = %spawnLocation.global_position + option_offset
	option_Display.scale = Vector2(.05, .05)
	option_Display.modulate = Color.TRANSPARENT
	if allowed:
		option_Display.stack_act = stack_act
	else:
		option_Display.stack_act = "Look"
	
	option_Display.connectedList = parent
	option_Display.origin_button = self
	parent.get_parent().add_child(option_Display)
	#parent.add_child(option_Display)
	option_Display.bring_up()
	
	return option_Display

#There's a function almost just like this in 
#"res://Scenes/UI/UIComponents/art_button.tscn"
#One day make a function that can do this kind of task globally from any node
func show_card() -> void:
	var considered: String = card.card_display()
	var node_tween: Tween = get_tree().create_tween().set_parallel(true)
	var card_display: Node
	match considered:
		"Pokemon":
			card_display = load("res://Scenes/UI/CardDisplay/PokemonCard.tscn").instantiate()
			card_display.checking = true
		"Trainer":
			card_display = Constants.trainer_card.instantiate()
		"Energy":
			card_display = Constants.energy_card.instantiate()
	
	card_display.card = card
	card_display.top_level = true
	card_display.position = global_position #Put on center of screen
	card_display.scale = Vector2(.05, .05)
	card_display.modulate = Color.TRANSPARENT
	card_display.name = str(card.name, " Card")
	add_child(card_display)
	parent.display = card_display
	parent.connect_display()
	
	node_tween.tween_property(card_display, "position", get_viewport_rect().size / 2 - Vector2(100,150), .1)
	node_tween.tween_property(card_display, "scale", Vector2.ONE, .1)
	node_tween.tween_property(card_display, "modulate", Color.WHITE, .1)
	
	#Can't do anything outside of interact with the check display
	Globals.checking_card()

func _gui_input(event):
	if not Globals.checking and not disabled:
		if event.is_action_pressed("A"):
			if parent.options:
				await parent.options.disapear()
			else:
				parent.options = show_options()
		elif event.is_action_pressed("L"):
			if parent.display:
				pass
			
			show_card()

#endregion
#--------------------------------------
