extends Resource
class_name SideState

@export var deck: Deck
##This should only be filled in for cases where usable deck starts at less than 60
@export var usable_deck: Array[Base_Card]
##This should only be filled in for cases where the user always starts with certian cards
##[br] if [member home_UD] is null, take these cards from the [member home_deck]
@export var initial_hand: Array[Base_Card]
@export var prize_cards: int = 6
@export var bench_size: int = 5
##The boolean will determine whether or not a slot is active or not
##[br] take these cards inside slots from deck if [member home_UD] is null
@export var slots: Dictionary[PokeSlot, bool]
@export var inital_supporter: Base_Card
