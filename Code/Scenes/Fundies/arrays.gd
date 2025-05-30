extends Node

var usable_deck: Array[Base_Card] = []
var hand: Array[Base_Card] = []
var discard_pile: Array[Base_Card] = []
var prize_cards: Array[Base_Card] = []
#Here in case they need to be used at some point
var reveal_stack: Array[Base_Card]
var cards_in_play: Array[Base_Card]

func sendStackDictionary() -> Dictionary[String, Array]:
	return {
 "Hand": hand, "Deck": usable_deck,
 "Discard": discard_pile, "Prize": prize_cards}

func append_to_arrays(type: String, card: Base_Card):
	match type:
		"Hand":
			hand.append(card)
		"Deck":
			usable_deck.append(card)
		"Discsard":
			discard_pile.append(card)
		"Prize":
			prize_cards.append(card)
		_:
			push_error(type, " is not in ", name)
			hand.append(card)

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
