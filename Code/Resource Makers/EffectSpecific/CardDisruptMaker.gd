extends Resource
class_name CardDisrupt

@export_group("Disruption")
@export var side: Constants.SIDES = Constants.SIDES.OPP
@export_enum("None", "Hand", "Deck", "Pokemon") var disrupting: int = 0
@export var pokemon_disrupt: Constants.SLOTS
##Card sends card and anything else attatched to it, Evolution just sends the evolution card back
@export_category("Send")
@export_enum("Card", "Evolution") var send: int = 0
@export_enum("Top Deck", "Bottom Deck", "Discard", "Hand") var send_to
@export var card_ammount: int = 0
@export var reveal: bool = false

func play_effect(fundies: Fundies):
	print("PLAY DISRUPT")
