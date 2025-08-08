@icon("res://Art/ProjectSpecific/recycle-bin.png")
extends Resource
class_name CardDisrupt

##Card sends card and anything else attatched to it, Evolution just sends the evolution card back
@export_enum("Card", "Evolution") var send: int = 0
@export_enum("Stack", "Slot") var from: int = 0
@export var send_to: Consts.STACKS = Consts.STACKS.DISCARD
@export var bottom_of_stack: bool = false
@export var shuffle: bool = false
##-1 mean remove all possible. This variable is ignored if [member variable_ammount] is filled
@export var card_ammount: int = 1
@export var variable_ammount: Comparator
@export var reveal: bool = false

@export_group("Choose From")
@export var side: Consts.SIDES = Consts.SIDES.DEFENDING
@export var card_options: Identifier
##If this is false then you cannot view the card being sent, depending on where, the results differ
##[br][i]ex. it's random from the hand but takes the top card from deck
@export var view: bool = true
@export var from_stack: Consts.STACKS = Consts.STACKS.HAND
@export var in_play_options: SlotAsk
@export var pokemon_disrupt: Consts.SLOTS

signal finished

func play_effect(reversable: bool = false, replace_num: int = -1) -> void:
	print("PLAY DISRUPT")
	
	finished.emit()
