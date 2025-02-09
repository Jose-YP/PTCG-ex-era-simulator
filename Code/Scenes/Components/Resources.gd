extends Node

@export var deck: Deck

var usable_deck: Array = deck.make_usable()
var hand: Array = []
var discard_pile: Array = []

func draw():
	hand.append(usable_deck.pop_front())

func search_for_hand(card: Base_Card):
	var location: int = usable_deck.find(card)
	hand.append(usable_deck.pop_at(location))
	usable_deck.shuffle()

func play_card(card: Base_Card):
	
	pass

func discard(card: Base_Card):
	var location: int = hand.find(card)
	discard_pile.append(hand.pop_at(location))
	

