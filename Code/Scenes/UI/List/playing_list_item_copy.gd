extends Button
class_name PlayingButton

@export var card: Base_Card
@export var option_offset: Vector2 = Vector2(30, 100)
@export_flags("Basic", "Evolution", "Item",
"Supporter", "Stadium", "Tool", "TM", "RSM", "Fossil",
 "Energy") var card_flags: int = 0

signal select

var parent: Node
var checking_card: Node
var disable_flags: int = 0
var stack_act: Consts.STACK_ACT
var allowed: bool = false
var from_id: Identifier

#--------------------------------------
#region INITALIZATION
func _ready() -> void:
	%Class.clear()
	card_flags = Convert.get_card_flags(card)
	
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
	#var check_first: Array[String] = Convert.flags_to_allowed_array(play_as)
	#var allowed_as = Globals.fundies.can_be_played(card)
	printt("ALLOW CHECK:",card.name,play_as & card_flags, play_as, card_flags)
	#printt("ALLOWED AS:", allowed_as)
	card_flags = play_as & card_flags
	
	#if allowed_as != card_flags:
		#disable_flags = card_flags - allowed_as
	allowed = true
	disabled = false

func not_allowed():
	allowed = false
	disabled = true

func allow_move_to(destination: Consts.STACKS):
	allowed = true
	disabled = false
	#match destination:
		#Consts.STACKS.DISCARD: stack_act = Consts.STACK_ACT.DISCARD
		#Consts.STACKS.PLAY: stack_act = Consts.STACK_ACT.TUTOR

func is_tutored() -> bool:
	return not parent is PlayingList

#endregion
#--------------------------------------

#--------------------------------------
#region ACTIONS
#probably should add a way to check if closer to left or right
func show_options() -> Node:
	var option_Display = load("res://Scenes/UI/Lists/item_options_copy.tscn").instantiate()
	option_Display.card_flags = card_flags
	option_Display.global_position = %RightSpawn.global_position + option_offset
	option_Display.scale = Vector2(.05, .05)
	option_Display.modulate = Color.TRANSPARENT
	if allowed:
		option_Display.stack_act = stack_act
	else:
		option_Display.stack_act = Consts.STACK_ACT.LOOK
	
	if %RightSpawn.global_position.x > float(get_window().size.x) / 2:
		option_Display.global_position = %LeftSpawn.global_position
		option_Display.global_position.x -= option_offset.x
		option_Display.global_position.y += option_offset.y
	
	option_Display.origin_button = self
	Globals.fundies.current_list.add_child(option_Display)
	option_Display.bring_up()
	
	return option_Display

func _gui_input(event):
	if not disabled:
		if event.is_action_pressed("A"):
			if stack_act == Consts.STACK_ACT.DISCARD or stack_act == Consts.STACK_ACT.ENSWAP:
				select.emit()
			elif stack_act != Consts.STACK_ACT.LOOK:
				if Globals.fundies.options:
					await Globals.control_disapear(Globals.fundies.options, .15, global_position)
				if not Globals.checking:
					Globals.fundies.options = show_options()
			elif stack_act == Consts.STACK_ACT.LOOK:
				Globals.show_card(card, self)
	if event.is_action_pressed("Check"):
		Globals.show_card(card, self)

#endregion
#--------------------------------------
