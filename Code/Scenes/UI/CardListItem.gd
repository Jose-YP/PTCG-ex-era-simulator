extends Button

@export var card: Base_Card
@export_flags("Basic", "Evolution", "Item",
"Supporter", "Stadium", "Tool", "TM", "RSM", "Fossil",
 "Energy") var card_flags: int = 0

@onready var marker_2d: Marker2D = $Marker2D

var parent: Node
var checking_card: Node
var interaction: String
var allowed: bool = false

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
	#disabled = true

func allow_move_to(destination: String):
	match destination:
		"Discard": interaction = "Discard"
		_: interaction = "Tutor"

#endregion
#--------------------------------------

#--------------------------------------
#region ACTIONS
func show_options() -> Node:
	var option_Display: Node = Constants.item_options.instantiate()
	var option_position = Vector2(size.x/2 - position.x - 80, global_position.y - size.y/4)
	option_position = Vector2(size.x/2 - global_position.x - 80, global_position.y + size.y/1.25)
	option_Display.card_flags = card_flags
	option_Display.global_position = option_position
	option_Display.scale = Vector2(.05, .05)
	option_Display.modulate = Color.TRANSPARENT
	option_Display.interaction = parent.interaction
	
	if allowed:
		option_Display.interaction = interaction
	else:
		option_Display.interaction = "Look"
	
	parent.add_child(option_Display)
	option_Display.origin_button = self
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
			card_display = Constants.poke_card.instantiate()
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
	if not Globals.checking:
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
