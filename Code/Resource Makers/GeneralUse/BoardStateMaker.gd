extends Resource
class_name BoardState

@export_enum("Win by taking", "Lose by Taking") var prize_rules: int = 0
@export_enum("Default","Always Heads", "Always Tails", "Alternate") var coin_rules: int = 0
@export_enum("Default", "Discard to Lost Zone", "Discard to Deck") var discard_rules: int = 0
@export_enum("Home", "Away", "Flip") var who_starts_first: int = 0
@export var doubles: bool = false
##Should the two players go through regular rules start?
##[br] Add a basic to active after drawing 7 cards
@export var default_start: bool = false
@export var stadium: Base_Card

@export_group("Home")
@export var side_home: Constants.PLAYER_TYPES = Constants.PLAYER_TYPES.PLAYER1
@export var home_deck: Deck
##This should only be filled in for cases where usable deck starts at less than 60
@export var home_UD: Array[Base_Card]
##This should only be filled in for cases where the user always starts with certian cards
##[br] if [member home_UD] is null, take these cards from the [member home_deck]
@export var home_hand: Array[Base_Card]
@export var home_prize_cards: int = 6
@export var home_bench_size: int = 5
##The boolean will determine whether or not a slot is active or not
##[br] take these cards inside slots from deck if [member home_UD] is null
@export var home_slots: Dictionary[PokeSlot, bool]
@export var home_supporter: Base_Card

@export_group("Away")
@export var side_away: Constants.PLAYER_TYPES = Constants.PLAYER_TYPES.CPU1
@export var away_deck: Deck
##This should only be filled in for cases where usable deck starts at less than 60
@export var away_UD: Array[Base_Card]
##This should only be filled in for cases where the user always starts with certian cards
##[br] if [member away_UD] is null, take these cards from the [member away_deck]
@export var away_hand: Array[Base_Card]
@export var away_prize_cards: int = 6
@export var away_bench_size: int = 5
##The boolean will determine whether or not a slot is active or not
##[br] take these cards inside slots from deck if [member away_UD] is null
@export var away_slots: Dictionary[PokeSlot, bool]
@export var away_supporter: Base_Card
