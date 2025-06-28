extends Resource
class_name CardDisrupt

##Card sends card and anything else attatched to it, Evolution just sends the evolution card back
@export_enum("Card", "Evolution") var send: int = 0
@export_enum("Stack", "Slot") var from: int = 0
@export var send_to: Constants.STACKS
@export var bottom_of_stack: bool = false
@export var shuffle: bool = false
@export var card_ammount: int = 0
@export var reveal: bool = false

@export_group("Type")
@export var side: Constants.SIDES = Constants.SIDES.DEFENDING
@export_subgroup("Stack")
@export var from_stack: Constants.STACKS = Constants.STACKS.HAND
@export var card_options: Identifier
@export_subgroup("Slot")
@export var in_play_options: SlotAsk
@export var pokemon_disrupt: Constants.SLOTS

signal finished

func play_effect():
	print("PLAY DISRUPT")
	
	finished.emit()
