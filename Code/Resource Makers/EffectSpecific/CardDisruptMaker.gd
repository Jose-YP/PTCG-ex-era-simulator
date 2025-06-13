extends Resource
class_name CardDisrupt

##Card sends card and anything else attatched to it, Evolution just sends the evolution card back
@export_group("Send")
@export_enum("Card", "Evolution") var send: int = 0
@export var bottom_of_stack: bool = false
@export var send_to: Constants.STACKS
@export var card_options: Identifier
@export var card_ammount: int = 0
@export var reveal: bool = false
@export_group("Disruption")
@export var side: Constants.SIDES = Constants.SIDES.DEFENDING
@export_enum("None", "Hand", "Deck", "Pokemon") var disrupting: int = 0
@export var pokemon_disrupt: Constants.SLOTS


func play_effect(fundies: Fundies):
	print("PLAY DISRUPT")
