extends Resource
class_name BoardState

@export_enum("Win by taking", "Lose by Taking") var prize_rules: int = 0
@export var coin_rules: Constants.COIN_RULES = Constants.COIN_RULES.REG
@export_enum("Default", "Discard to Lost Zone", "Discard to Deck") var discard_rules: int = 0
@export_enum("Home", "Away", "Flip") var who_starts_first: int = 0
@export var doubles: bool = false
##Should the two players go through regular rules start?
##[br] Add a basic to active after drawing 7 cards
@export var default_start: bool = false
@export var stadium: Base_Card

@export var home_side: Constants.PLAYER_TYPES = Constants.PLAYER_TYPES.PLAYER
@export var home: SideState
@export var away_side: Constants.PLAYER_TYPES = Constants.PLAYER_TYPES.CPU
@export var away: SideState

func get_player_type(home_bool: bool) -> Constants.PLAYER_TYPES:
	return home_side if home_bool else away_side

func get_side(home_bool: bool) -> SideState:
	return home if home_bool else away
