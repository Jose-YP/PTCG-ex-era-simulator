extends Node

@export var deck: Deck
@export var first: bool = true
@export_enum("Player1", "Player2", "CPU") var side: String = "Player1"

signal show_list(can_select: bool, message: String, looking_at: String, list: Array[Base_Card])

var usable_deck: Array[Base_Card] = []
var hand: Array[Base_Card] = []
var discard_pile: Array[Base_Card] = []
var mulligans: int = 0
var first_turn: bool = false

#--------------------------------------
#region INITALIZATION
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
		card.print_name()
		if card.categories & 1 or card.fossil:
			can_start = true
			start_string = "Select a Basic Pokemon"
	
	print(start_string)
	show_list.emit(can_start, start_string, "HAND", hand)

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
#endregion
#--------------------------------------
