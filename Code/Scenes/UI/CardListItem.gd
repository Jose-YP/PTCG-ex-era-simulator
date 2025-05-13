extends Button

@export var card: Base_Card
@export_flags("Basic", "Evolution", "Item",
"Supporter", "Stadium", "Tool", "TM", "RSM", "Fossil",
 "Energy") var card_flags: int = 0
@export_enum("Hand", "Search", "Look") var searching: String = "Hand"

@onready var marker_2d: Marker2D = $Marker2D

var parent: Node
var checking_card: Node
var allowed: bool = false

#--------------------------------------
#region INITALIZATION
func _ready() -> void:
	%Class.clear()
	if card.categories & 1:
		%Class.append_text(card.pokemon_properties.evo_stage)
		if card.pokemon_properties.evo_stage == "Basic":
			card_flags += Conversions.get_allowed_flags("Basic")
		elif card.fossil: 
			card_flags += Conversions.get_allowed_flags("Fossil")
		else:
			card_flags += Conversions.get_allowed_flags("Evolution")
		
	elif card.categories & 2:
		var considered = card.trainer_properties.considered
		if considered == "Rocket's Secret Machine": considered = "RSM"
		
		card_flags += Conversions.get_allowed_flags(considered)
		
		if considered == "Supporter": considered = "Support"
		
		%Class.append_text(considered)
	
	else:
		card_flags += Conversions.get_allowed_flags("Energy")
		%Class.append_text(card.energy_properties.considered)
	
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

#endregion
#--------------------------------------

#--------------------------------------
#region ACTIONS
func show_options() -> Node:
	var option_Display: Node = Constants.item_options.instantiate()
	var option_position = position + Vector2(80, 115)
	option_position = Vector2(position.x, global_position.y)
	print(option_position, option_Display.size.x * 2 + 10)
	#Find a way to prevent it from going off screen
	#option_position.x = clamp(option_position.x, 60, get_viewport().size.x - option_Display.size.x)
	#option_position.y = clamp(option_position.y, 30, get_viewport().size.y - 30)
	
	print(option_position)
	option_Display.card_flags = card_flags
	option_Display.position = option_position
	option_Display.scale = Vector2(.05, .05)
	option_Display.modulate = Color.TRANSPARENT
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
	if allowed and not Globals.checking:
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
