extends Control
class_name Tutor_Box

@export var connected_list: PlayingList
@export var search: Search
@export var start_text: String
@export var list_item: PackedScene

@onready var req_text: RichTextLabel = %ReqText
@onready var status: RichTextLabel = %Status
@onready var card_list: VBoxContainer = %CardList

signal no_more_adding(id: Identifier)

var tutor_requiremnts: Dictionary[Identifier, Array]
var based_on: Array[PokeSlot]
var max_tutor: int = 0
var stack_size: int = 0
var options: Node

func _ready() -> void:
	SignalBus.connect("tutor_card", add_card)
	SignalBus.connect("cancel_tutor", remove_card)

func set_up_tutor():
	var text: String = start_text
	for i in range(search.of_this.size()):
		max_tutor += search.how_many[i]
		
		if text != start_text:
			text = str(text, ", & ", search.how_many[i], " ", search.of_this[i].description)
		else:
			text = str(text, " ", search.how_many[i], " ", search.of_this[i].description)
	
	for id in search.of_this:
		tutor_requiremnts[id] = []
	
	print(text)
	req_text.append_text(text)
	status.clear()
	status.append_text(str("[center]Tutor Number: 0 / ", max_tutor))

func update_tutor():
	var current_num: int = 0
	#Check how may cards are added in the tutor
	for tutor in tutor_requiremnts:
		current_num += tutor_requiremnts[tutor].size()
	
	status.clear()
	status.append_text(str("[center]Tutor Number: ", current_num," / ", max_tutor))
	#If the max_tutor is satisfied then allow the confirm OR
	#If there aren't any cards left from the stack, allow confirmation
	%Confirm.disabled = current_num != max_tutor or current_num == stack_size

func add_card(card: Base_Card):
	card.print_info()
	for i in range(search.of_this.size()):
		var num: int = search.how_many[i]
		var id: Identifier = search.of_this[i]
		#Check if this card is allowed to be added
		if id.identifier_bool(card, based_on) and tutor_requiremnts[id].size() < num:
			tutor_requiremnts[id].append(show_card(card, id))
			
			#If the search identifier is now satisfied make sure no more can be added
			if tutor_requiremnts[id].size() >= num:
				no_more_adding.emit(id)
			update_tutor()
			return
	#Only ends up here if a card cannot be added for some reason
	printerr("Can't add ", card.name, " tutor condition doesn't allow it")

func remove_card(button: Button):
	print(tutor_requiremnts)
	for id in tutor_requiremnts:
		#Buttons are recorded so each one is unique and can only be found in one place
		if tutor_requiremnts[id].find(button) != -1:
			tutor_requiremnts[id].erase(button)
			button.queue_free()
			connected_list.add_item(button.card)
	
	connected_list.sort_list()
	update_tutor()

func show_card(card: Base_Card, id: Identifier) -> Button:
	var making = list_item.instantiate()
	making.card = card
	making.parent = self
	making.from_id = id
	%CardList.add_child(making)
	
	connected_list.remove_item(card)
	making.allow_move_to(connected_list.stack)
	return making

func _on_confirm_pressed() -> void:
	var all_tutored: Array[Base_Card]
	
	for id in tutor_requiremnts:
		for button in tutor_requiremnts[id]:
			all_tutored.append(button.card)
	
	print("Moving ", all_tutored, " from ", search.and_then.where, " to ", search.where)
	SignalBus.swap_card_location.emit(all_tutored, search.and_then.where, search.where)

func _on_cancel_pressed() -> void:
	pass # Replace with function body.

func _on_no_more_adding(id: Identifier) -> void:
	print("Got every card that is ", id.description)
