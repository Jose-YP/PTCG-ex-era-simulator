extends Resource
class_name CardDisrupt

@export_group("Disruption")
@export_enum("Player", "Opponent") var disrupt_target: int = 0
@export_enum("None", "Hand", "Deck", "Active", "Bench", "Pokemon") var disrupting: int = 0
##Card sends card and anything else attatched to it, Evolution just sends the evolution card back
@export_enum("Card", "Evolution") var send: int = 0
@export_enum("Top Deck", "Bottom Deck", "Discard", "Hand") var send_to
@export var card_ammount: int = 0
@export var reveal: bool = false
