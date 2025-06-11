extends Resource
class_name Search

##Which section will the player search (yes there is defender searching)
@export var side: Constants.SIDES
@export var where: Constants.STACKS
##Will the identifier base it's results on anything?
@export var based_on_side: Constants.SIDES
@export var based_on_slots: Constants.SLOTS

##How many cards in the desired section can you check.
##-1 means all cards. For certain cards that look at a bit of the top of the deck.
@export_range(-1,60, 1) var portion: int = -1
##How many cards can the user pick 
@export var how_many: Array[int] = [1]
##Incase of variable search ammounts
@export var variable_ammount: Counter
##For each item in identifier, search how_many
@export var of_this: Array[Identifier]
##Where do the tutored cards go?
@export var and_then: Placement
##Should the defender see any of these cards?
@export var reveal: bool = true

func play_effect(fundies: Fundies):
	print("PLAY SEARCH")
	var based_on_cards: Array[PokeSlot]
	
	if based_on_side != 0 and based_on_slots != 0:
		based_on_cards = fundies.get_slots(based_on_side, based_on_slots)
		print("BASED ON ", based_on_side, based_on_slots, based_on_cards)
	
	fundies.player_resources.search_array(self, based_on_cards)
