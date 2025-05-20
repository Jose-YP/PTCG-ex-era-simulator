@icon("res://Art/ProjectSpecific/cards.png")
extends Node
class_name Deck_Manipulator

@export var deck: Deck
@export var first: bool = false
@export_range(1,6) var prize_count: int = 6
@export_enum("Player1", "Player2", "CPU") var side: String = "Player1"

@onready var fundies: Fundies = $".."
@onready var arrays: Node = $Arrays

#signal show_list(can_select: bool, message: String, looking_at: String, list: Array[Base_Card])
signal update_resources()

#var reveal_stack: Array[Base_Card]
#var usable_deck: Array[Base_Card] = []
#var hand: Array[Base_Card] = []
#var discard_pile: Array[Base_Card] = []
#var prize_cards: Array[Base_Card] = []
var mulligans: int = 0
var mulligan_array: Array[Array]
var supporter_used: bool = false

#--------------------------------------
#region INITALIZATION
func _ready():
	SignalBus.connect("show_list", spawn_list)
	SignalBus.connect("swap_card_location", move_card)
	
	if deck: 
		arrays.usable_deck = deck.make_usable()
		arrays.usable_deck.shuffle()
		update_lists()

func assign_deck(assigned_deck):
	arrays.usable_deck = assigned_deck.make_usable()
	arrays.usable_deck.shuffle()

func draw_starting():
	draw(7)
	print("----------",side,"---------")
	check_starting()

func check_starting():
	var can_start: bool = false
	var start_string: String = "There are no basic Pokemon in the starting hand"
	for card in arrays.hand:
		if card.is_considered("Basic") or card.fossil:
			can_start = true
			start_string = "Select a Basic Pokemon"
	
	print(start_string)
	print(arrays.hand)
	if can_start:
		spawn_list(true, "Hand", "Play", start_string, Conversions.get_allowed_flags("Start"))
	else:
		#If you can't start with current hand, mulligan
		#record mulligans for later
		mulligans += 1
		mulligan_array.append(arrays.hand)
		shuffle_hand_back()
		draw_starting()

func fill_prizes():
	while (arrays.prize_cards.size() != prize_count):
		arrays.append_to_arrays("Prize", arrays.usable_deck.pop_front())

#endregion
#--------------------------------------

#--------------------------------------
#region CARD MOVEMENT
func draw(times: int = 1): #From deck to hand
	for i in range(times):
		arrays.append_to_arrays("Hand", arrays.usable_deck.pop_front())
	
	update_lists()

func move_card(card: Base_Card, from: String, towards: String, shuffle: bool = true): #From X to Y
	var dict: Dictionary[String, Array] = arrays.sendStackDictionary()
	var location: int = arrays.dict[from].find(card)
	arrays.append_to_arrays(towards, dict[from].pop_at(location))
	
	if (from == "Deck" or towards == "Deck") and shuffle:
		arrays.usable_deck.shuffle()
	
	update_lists()

func play_card(card: Base_Card): #From hand to Y
	print("PLAY ", card.name)
	arrays.hand.erase(card)
	update_lists()
	card.print_info()

func ontop_deck(_card: Base_Card): #From X to atop Deck
	
	pass

func shuffle_hand_back():
	arrays.usable_deck.append_array(arrays.hand)
	arrays.hand.clear()
	arrays.usable_deck.shuffle()
	update_lists()

func discard_card(card: Base_Card):
	arrays.append_to_array("Discard", card)
	update_lists()

#endregion
#--------------------------------------

#--------------------------------------
#region CARD DISPLAY
func update_lists():
	var dict: Dictionary[String, Array] = arrays.sendStackDictionary()
	for stack in dict:
		fundies.player_side.non_mon.update_stack(stack, dict[stack].size())

func spawn_list(monitor_side: bool, which: String, interaction: String = "Look",\
 instructions: String = "", allowed: int = Conversions.get_allowed_flags()):
	var designated: Array[Base_Card] = arrays.sendStackDictionary()[which]
	var display_text: String
	var spawn_from: Vector2
	
	if monitor_side:
		match which:
			"Hand":
				display_text = "HAND"
				spawn_from = fundies.player_side.non_mon.stacks["Hand"].global_position
			"Deck":
				display_text = "DECK"
				spawn_from = fundies.player_side.non_mon.stacks["Deck"].global_position
			"Discard":
				display_text = "DISCARD PILE"
				spawn_from = fundies.player_side.non_mon.stacks["Discard"].global_position
			"Prize":
				display_text = "PRIZE CARDS"
				spawn_from = fundies.player_side.non_mon.stacks["Prize"].global_position
			_:
				push_error("Can't find list specified: ", which)
	
	instantiate_list(designated, which, display_text, instructions, allowed, interaction, spawn_from)

func instantiate_list(specified_list: Array[Base_Card], which: String, display_text: String, \
 using_string: String, allowed: int, interaction: String = "Look", spawn_from: Vector2 = Vector2.ZERO):
	var hand_list: PackedScene = Constants.playing_list
	var new_node = hand_list.instantiate()
	
	new_node.list = specified_list
	new_node.top_level = true
	new_node.allowed = allowed
	new_node.display_text = display_text
	new_node.instruction_text = using_string
	new_node.old_posiiton = spawn_from
	new_node.interaction = interaction
	new_node.stack = which
	add_sibling(new_node)
	fundies.current_list = new_node

func pick_prize():
	pass

func show_reveal_stack(reveal_slot):
	if arrays.reveal_stack.size() != 0:
		reveal_slot.art.texture = arrays.reveal_stack[-1]
	else:
		reveal_slot.art.texture = null

#endregion
#--------------------------------------
