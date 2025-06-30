extends Resource
class_name Deck

@export var cards: Dictionary[Base_Card, int]
enum DECK_STATUS {READY, INCOMPLETE, ILLEGAL, TOOBIG}
var status: DECK_STATUS = DECK_STATUS.READY

func is_legal() -> bool:
	var count: int = 0
	for card in cards:
		var basic_energy: bool = card.is_considered("Basic")
		if not basic_energy and cards[card] > 4:
			status = DECK_STATUS.ILLEGAL
			return false
		count += cards[card]
	
	if count > 60:
		status = DECK_STATUS.TOOBIG
		return false
	if count < 60:
		status = DECK_STATUS.INCOMPLETE
		return false
	
	status = DECK_STATUS.READY
	return true

func make_usable() -> Array[Base_Card]:
	var usable: Array[Base_Card] = []
	for card in cards:
		for i in cards[card]:
			#These have to be unique to make search function
			usable.append(card.duplicate())
	
	return usable
