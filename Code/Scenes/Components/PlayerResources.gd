extends Node
class_name Deck_Manipulator

@export var deck: Deck
@export var first: bool = true
@export_enum("Player1", "Player2", "CPU") var side: String = "Player1"

signal show_list(can_select: bool, message: String, looking_at: String, list: Array[Base_Card])

var reveal_stack: Array[Base_Card]
var usable_deck: Array[Base_Card] = []
var hand: Array[Base_Card] = []
var discard_pile: Array[Base_Card] = []
var mulligans: int = 0
var mulligan_array: Array[Array]
var first_turn: bool = false

#--------------------------------------
#region INITALIZATION
func _ready():
	SignalBus.connect("show_hand", spawn_hand)
	
	
	if deck: 
		usable_deck = deck.make_usable()
		usable_deck.shuffle()

func assign_deck(assigned_deck):
	usable_deck = assigned_deck.make_usable()
	usable_deck.shuffle()

func draw_starting():
	draw(7)
	print("----------",side,"---------")
	check_starting()

func check_starting():
	var can_start: bool = false
	var start_string: String = "There are no basic Pokemon in the starting hand"
	for card in hand:
		if card.is_considered("Basic") or card.fossil:
			can_start = true
			start_string = "Select a Basic Pokemon"
	
	print(start_string)
	print(hand)
	if can_start:
		spawn_hand(side, start_string, Conversions.get_allowed_flags("Start"))
	else:
		#If you can't start with current hand, mulligan
		#record mulligans for later
		mulligans += 1
		mulligan_array.append(hand)
		shuffle_hand_back()
		draw_starting()
		

#endregion
#--------------------------------------

#--------------------------------------
#region CARD MOVEMENT
func draw(times: int = 1): #From deck to hand
	for i in range(times):
		hand.append(usable_deck.pop_front())

func move_card(card: Base_Card, from: Array, towards: Array): #From X to Y
	var location: int = from.find(card)
	towards.append(from.pop_at(location))
	
	if from == usable_deck:
		usable_deck.shuffle()

func play_card(_card: Base_Card): #From hand to Y
	
	pass

func ontop_deck(_card: Base_Card): #From X to atop Deck
	
	pass

func shuffle_hand_back():
	usable_deck.append_array(hand)
	hand.clear()
	usable_deck.shuffle()

#endregion
#--------------------------------------

#--------------------------------------
#region CARD DISPLAY
func spawn_hand(monitor_side: String, using_string: String, allowed: int = Conversions.get_allowed_flags()):
	if monitor_side == side:
		var hand_list: PackedScene = Constants.playing_list
		var new_node = hand_list.instantiate()
		
		new_node.list = hand
		new_node.top_level = true
		new_node.allowed = allowed
		new_node.display_text = "HAND"
		new_node.instruction_text = using_string
		
		add_sibling(new_node)
		#new_node.set_items()

func show_reveal_stack(reveal_slot):
	if reveal_stack.size() != 0:
		reveal_slot.art.texture = reveal_stack[-1]
	else:
		reveal_slot.art.texture = null

#endregion
#--------------------------------------
