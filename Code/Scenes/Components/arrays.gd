extends Node

var reveal_stack: Array[Base_Card]
var usable_deck: Array[Base_Card] = []
var hand: Array[Base_Card] = []
var discard_pile: Array[Base_Card] = []
var prize_cards: Array[Base_Card] = []
@onready var stackDictionary: Dictionary[String, Array] = {
 "Hand": hand, "Deck": usable_deck,
 "Discard": discard_pile, "Prize": prize_cards}

func append_to_arrays(type: String, card: Base_Card):
	pass

func get_array(type: String) -> Array[Base_Card]:
	match type:
		"Hand":
			return hand
		"Deck":
			return usable_deck
		"Discsard":
			return discard_pile
		"Prize":
			return prize_cards
		_:
			push_error(type, " is not in ", name)
			return hand

func none_lost() -> bool:
	return (usable_deck.size() + discard_pile.size() + hand.size() + prize_cards.size()) == 60
