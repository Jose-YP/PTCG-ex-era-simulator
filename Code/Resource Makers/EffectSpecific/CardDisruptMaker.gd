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
@export var portion: int = -1
@export var from_stack: Consts.STACKS = Consts.STACKS.HAND
##If it's -1, choose every possible choice acoording to [member in_play_options] 
@export_range(-1,6,1) var slot_choose_num: int = -1
@export var in_play_options: SlotAsk
@export var pokemon_disrupt: Consts.SLOTS

signal finished

func play_effect(reversable: bool = false, replace_num: int = -1) -> void:
	print("PLAY DISRUPT")
	var home: bool = Globals.fundies.get_considered_home(side)
	var stacks: CardStacks = Globals.fundies.stack_manager.get_stacks(home)
	var num: int = card_ammount
	if variable_ammount:
		num = variable_ammount.start_comparision()
		if num < 1:
			finished.emit()
			return
	
	#Discard from a stack
	if from == 0:
		#Choose
		if view:
			var disc_box: DiscardList = Consts.discard_box.instantiate()
			
			disc_box.list = stacks.identifier_search(from_stack, card_options, [], portion)
			disc_box.stack = from_stack
			disc_box.stack_act = Consts.STACK_ACT.DISCARD
			disc_box.destination = send_to
			disc_box.discard_num = num
			disc_box.home = Globals.fundies.get_considered_home(side)
			disc_box.energy_discard = false
			if reversable:
				disc_box.allow_reverse()
			
			Globals.full_ui.set_top_ui(disc_box)
			
			await disc_box.finished
		#Random
		else:
			var list = stacks.identifier_search(from_stack, card_options, [], portion)
			var disc_from: Array[Base_Card]
			var lets_discard: Array[Base_Card]
			
			for card in list:
				if list[card]:
					disc_from.append(card)
			for i in num:
				lets_discard.append(disc_from.pick_random())
			print("Let's Discard...")
			for card in lets_discard:
				print(card.get_formal_name())
			
			stacks.move_cards(lets_discard, from_stack, send_to)
	
	#Discard from a slot
	else:
		var slots: Array[PokeSlot] = Globals.full_ui.get_ask_slots(in_play_options)
		if slot_choose_num == -1:
			for slot in slots:
				var moving_cards: Array[Base_Card] = slot.disrupted_cards(card_options, send)
				pass
		else:
			pass
		
	
	Globals.full_ui.get_home_side(home).non_mon.sync_stacks()
	finished.emit()
