@icon("res://Art/ProjectSpecific/cards.png")
extends Node
class_name Deck_Manipulator

@export var deck: Deck
@export var first_turn: bool = false
@export var attatched_energy: bool = false
@export var supporter_played: bool = false
@export_range(1,6) var prize_count: int = 6
@export_enum("Player1", "Player2", "CPU") var side: String = "Player1"
@export_flags("Basic", "Evolution", "Item",
"Supporter","Stadium", "Tool", "TM", "RSM", "Fossil",
 "Energy") var allowed_play: int = 1023

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
	#SignalBus.connect("move_cards", move_cards)
	
	if deck: 
		arrays.usable_deck = deck.make_usable()
		arrays.usable_deck.shuffle()
		update_lists()

func assign_deck(assigned_deck):
	arrays.usable_deck = assigned_deck.make_usable()
	arrays.usable_deck.shuffle()

func draw_starting():
	allowed_play = 1
	draw(7)
	print("----------",side,"---------")
	check_starting()

func check_starting():
	var can_start: bool = false
	var start_string: String = "There are no basic Pokemon in the starting hand"
	var hand_dict: Dictionary[Base_Card, bool]
	for card in arrays.hand:
		if card.is_considered("Basic") or card.fossil:
			can_start = true
			start_string = "Select a Basic Pokemon"
			hand_dict[card] = true
		else: hand_dict[card] = false
	
	print(start_string)
	print(arrays.hand)
	print(hand_dict)
	if can_start:
		spawn_list(true, hand_dict, "Play", start_string)
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

func move_cards(cards: Array[Base_Card], from: String, towards: String, shuffle: bool = true):
	var dict: Dictionary[String, Array] = arrays.sendStackDictionary()
	for card in cards: 
		#Remove all tutored cards from source first
		var adding_card = dict[from].pop_at(dict[from].find(card))
		#Now it can be added back to the towards array
		arrays.append_to_arrays(towards, adding_card)
	
	if (from == "Deck" or towards == "Deck") and shuffle:
		arrays.usable_deck.shuffle()
	
	update_lists()

func play_card(card: Base_Card): #From hand to Y
	print("PLAY ", card.name)
	arrays.hand.erase(card)
	update_lists()
	card.print_info()
	fundies.slot_ui_actions.reset_ui()
	

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

func get_list(which: String) -> Dictionary[Base_Card, bool]:
	var dict: Dictionary[Base_Card, bool]
	determine_allowed()
	
	#Everything should check if they're allowed generally, then...
	#Basic and \fossil should check if there is any empty space
	#Evolution should check if there's anything to evolve from
	#Support should check if any was already played
	#Tool should ceck if there's any mons with nothing equipped
	
	for card in arrays.get_array(which):
		var flags = Conversions.get_card_flags(card)
		if flags & allowed_play:
			
			
			dict[card] = true
		else: dict[card] = false
	
	return dict

func spawn_list(monitor_side: bool, list: Dictionary[Base_Card, bool],\
 interaction: String = "Look", instructions: String = "", display_text: String = "HAND"):
	var spawn_from: Vector2
	var which: String
	
	if monitor_side:
		match display_text:
			"HAND":
				which = "Hand"
				spawn_from = fundies.player_side.non_mon.stacks["Hand"].global_position
			"DECK":
				which = "Deck"
				spawn_from = fundies.player_side.non_mon.stacks["Deck"].global_position
			"DISCARD PILE":
				which = "Discard"
				spawn_from = fundies.player_side.non_mon.stacks["Discard"].global_position
			"PRIZE CARDS":
				which = "Prize"
				spawn_from = fundies.player_side.non_mon.stacks["Prize"].global_position
			_:
				push_error("Can't find list specified: ", which)
	
	instantiate_list(list, interaction, which, display_text, instructions, spawn_from)

func instantiate_list(specified_list: Dictionary[Base_Card, bool],\
 interaction: String = "Look", which: String = "Hand"\
 ,display_text: String = "", using_string: String = "",  spawn_from: Vector2 = Vector2.ZERO):
	var hand_list: PackedScene = Constants.playing_list
	var new_node = hand_list.instantiate()
	
	new_node.list = specified_list
	new_node.top_level = true
	new_node.display_text = display_text
	new_node.instruction_text = using_string
	new_node.old_posiiton = spawn_from
	new_node.interaction = interaction
	new_node.stack = which
	new_node.allowed_as = allowed_play
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

#--------------------------------------
#region TUTORING
func search_array(search: Search, based_on: Array[PokeSlot]):
	var from: Array[Base_Card] = arrays.get_array(search.where)
	var search_results: Array[Dictionary]
	for tutor in search.of_this:
		print("--------------------")
		print(tutor)
		print("--------------------")
		search_results.append(identifier_search(from, based_on, tutor))
	
	return search_results

func identifier_search(list: Array[Base_Card], based_on: Array[PokeSlot],\
 identifier: Identifier) -> Dictionary[Base_Card,bool]:
	var valid_dictionary: Dictionary[Base_Card,bool]
	
	for card in list:
		if identifier.identifier_bool(card, based_on):
			valid_dictionary[card] = true
		else: valid_dictionary[card] = false
	
	print("--------------------")
	print("INVALID CARDS: ")
	for card in valid_dictionary: if not valid_dictionary[card]: print(card.name)
	print("--------------------")
	print("--------------------")
	print("VALID CARDS: ")
	for card in valid_dictionary: if valid_dictionary[card]: print(card.name)
	print("--------------------")
	return valid_dictionary

#endregion
#--------------------------------------

func determine_allowed():
	allowed_play = 1023
	
	if first_turn:
		allowed_play -= 8
	if attatched_energy:
		allowed_play -= 512
