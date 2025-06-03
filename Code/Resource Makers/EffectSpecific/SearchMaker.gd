extends Resource
class_name Search

@export_enum("Player", "Opponent") var side
@export_enum("Discard", "Deck") var where
@export var based_on_side: Constants.SIDES
@export var based_on_slots: Constants.SLOTS


##How many cards in the desired section can you check.
##-1 means all cards. For certain cards that look at a bit of the top of the deck.
@export_range(-1,60, 1) var portion: int = -1
##How many cards can the user pick 
@export var how_many: Array[int] = [1]
##For each item in identifier, search how_many
@export var of_this: Array[Identifier]
@export var and_then: Placement
@export var reveal: bool = true

func play_effect(fundies: Fundies):
	print("PLAY SEARCH")
	var based_on_cards: Array[PokeSlot]
	
	if based_on_side != 0 and based_on_slots != 0:
		based_on_cards = fundies.get_slots(Constants.SIDES.PLAYER, Constants.SLOTS.ACTIVE)
		print("BASED ON ", based_on_side, based_on_slots, based_on_cards)
	
	fundies.player_resources.search_array(self, based_on_cards)
