extends Node

var reveal_stack: Array[Base_Card]
var usable_deck: Array[Base_Card] = []
var hand: Array[Base_Card] = []
var discard_pile: Array[Base_Card] = []
var prize_cards: Array[Base_Card] = []

func none_lost() -> bool:
	return (usable_deck.size() + discard_pile.size() + hand.size() + prize_cards.size()) == 60
