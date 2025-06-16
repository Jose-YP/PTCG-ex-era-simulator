extends Node
class_name Card_Arrays

var usable_deck: Array[Base_Card] = []
var hand: Array[Base_Card] = []
var discard_pile: Array[Base_Card] = []
var prize_cards: Array[Base_Card] = []
#Here in case they need to be used at some point
var reveal_stack: Array[Base_Card]
var cards_in_play: Array[Base_Card]

func sendStackDictionary() -> Dictionary[Constants.STACKS, Array]:
	return {
 Constants.STACKS.HAND: hand, Constants.STACKS.DECK: usable_deck,
 Constants.STACKS.DISCARD: discard_pile, Constants.STACKS.PRIZE: prize_cards}

func append_to_arrays(type: Constants.STACKS, card: Base_Card, top_deck: bool = false):
	#Constants.STACKS.DECK and bottom_stack
	match type:
		Constants.STACKS.HAND:
			hand.append(card)
		Constants.STACKS.DECK:
			if top_deck: #This is generally slower so only when top deck is important
				usable_deck.push_front(card)
			else:
				usable_deck.append(card)
			
		Constants.STACKS.DISCARD:
			discard_pile.append(card)
		Constants.STACKS.PRIZE:
			prize_cards.append(card)
		_:
			push_error(type, " is not in ", name)
			hand.append(card)

func get_array(type: Constants.STACKS) -> Array[Base_Card]:
	match type:
		Constants.STACKS.HAND:
			return hand
		Constants.STACKS.DECK:
			return usable_deck
		Constants.STACKS.DISCARD:
			return discard_pile
		Constants.STACKS.PRIZE:
			return prize_cards
		_:
			push_error(type, " is not in ", name)
			return hand

func none_lost() -> bool:
	return (usable_deck.size() + discard_pile.size() + hand.size() + prize_cards.size()) == 60
