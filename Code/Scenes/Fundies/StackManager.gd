@icon("res://Art/ProjectSpecific/cards.png")
extends Node
class_name StackManager

@export var first_turn: bool = false
@export var attatched_energy: bool = false
@export var supporter_played: bool = false
@export_range(1,6) var prize_count: int = 6

#var reveal_stack: Array[Base_Card]
var operate_home: bool = true
var home_stacks: CardStacks
var away_stacks: CardStacks
var mulligans: int = 0
var mulligan_array: Array[Array]
var supporter_used: bool = false

#--------------------------------------
#region INITALIZATION
func _ready():
	SignalBus.connect("show_list", spawn_list)
	SignalBus.connect("swap_card_location", placement_handling)
	SignalBus.connect("show_energy_attatched", spawn_energy_list)
	SignalBus.connect("reorder_cards", reorder_handling)

func assign_card_stacks(stacks: CardStacks, side: bool):
	if side:
		home_stacks = stacks
	else:
		away_stacks = stacks

func draw_starting():
	draw(7)
	print("----------",operate_home,"---------")
	check_starting()

func check_starting():
	var can_start: bool = false
	var start_string: String = "There are no basic Pokemon in the starting hand"
	var hand_dict: Dictionary[Base_Card, bool]
	for card in get_stacks(operate_home).hand:
		if card.is_considered("Basic") or card.fossil:
			can_start = true
			start_string = "Select a Basic Pokemon"
			hand_dict[card] = true
		else: hand_dict[card] = false
	
	if can_start:
		instantiate_list(hand_dict, Constants.STACKS.HAND,
		 Constants.STACK_ACT.PLAY, start_string)
	else:
		#If you can't start with current hand, mulligan
		#record mulligans for later
		mulligans += 1
		mulligan_array.append(get_stacks(operate_home).hand)
		shuffle_hand_back()
		draw_starting()

func fill_prizes():
	var stacks: CardStacks = get_stacks(operate_home)
	while (stacks.prize_cards.size() != prize_count):
		stacks.append_to_arrays(Constants.STACKS.PRIZE, stacks.usable_deck.pop_front())

#endregion
#--------------------------------------

#--------------------------------------
#region CARD MOVEMENT
func draw(times: int = 1, top: bool = true): #From deck to hand
	var stacks: CardStacks = get_stacks(operate_home)
	for i in range(times):
		stacks.append_to_arrays(Constants.STACKS.HAND,
		 stacks.usable_deck.pop_front() if top else stacks.usable_deck.pop_back())
	
	update_lists()

func play_card(card: Base_Card, home: bool): #From hand to Y
	print("PLAY ", card.name)
	get_stacks(home).hand.erase(card)
	update_lists()
	card.print_info()
	discard_card(card)
	Globals.fundies.ui_actions.reset_ui()

func play_supporter(card: Base_Card, home: bool):
	var side: CardSideUI = Globals.full_ui.get_side(home)
	var stack: CardStacks = get_stacks(home)
	side.non_mon.show_supporter(card)
	#Whichever one works stays
	stack.hand.erase(card)
	stack.cards_in_play.append(card)
	stack.none_lost()

func ontop_deck(_card: Base_Card): #From X to atop Deck
	pass

func shuffle_hand_back():
	var stacks: CardStacks = get_stacks(operate_home)
	stacks.usable_deck.append_array(stacks.hand)
	stacks.hand.clear()
	stacks.usable_deck.shuffle()
	update_lists()

func discard_card(card: Base_Card):
	var stack = get_stacks(operate_home)
	stack.append_to_arrays(Constants.STACKS.DISCARD, card)
	update_lists()

#endregion
#--------------------------------------

#--------------------------------------
#region CARD DISPLAY
func update_lists():
	#Needs a lot of updates
	Globals.full_ui.update_stacks(home_stacks.sendStackDictionary(), Constants.PLAYER_TYPES.PLAYER)
	Globals.full_ui.update_stacks(away_stacks.sendStackDictionary(), Constants.PLAYER_TYPES.CPU)

func get_list(which: Constants.STACKS) -> Dictionary[Base_Card, bool]:
	var dict: Dictionary[Base_Card, bool]
	var allowed_as: int = determine_allowed()
	#Everything should check if they're allowed generally, then...
	#Basic and \fossil should check if there is any empty space
	#Evolution should check if there's anything to evolve from
	#Support should check if any was already played
	#Tool should ceck if there's any mons with nothing equipped
	
	for card in get_stacks(operate_home).get_array(which):
		var flags = Conversions.get_card_flags(card)
		dict[card] = flags && allowed_as
	
	return dict

func spawn_list(monitor_side: bool, which: Constants.STACKS, stack_act: Constants.STACK_ACT):
	operate_home = monitor_side
	
	instantiate_list(get_list(which), which, stack_act)

func instantiate_list(specified_list: Dictionary[Base_Card, bool], which: Constants.STACKS,\
 stack_act: Constants.STACK_ACT = Constants.STACK_ACT.LOOK, instructions: String = ""):
	var new_node = Constants.reg_list.instantiate()
	
	new_node.list = specified_list
	
	new_node.top_level = true
	new_node.home = operate_home
	new_node.old_pos = Globals.fundies.get_side_ui().non_mon.stacks[which].global_position
	new_node.stack_act = stack_act
	new_node.stack = which
	new_node.allowed_as = determine_allowed()
	new_node.instruction_text = instructions
	
	add_sibling(new_node)
	Globals.fundies.current_list = new_node

func pick_prize():
	pass

func spawn_discard_list(specified_list: Dictionary[Base_Card, bool],
 from: Constants.STACKS, to: Constants.STACKS) -> DiscardList:
	var dis_box: DiscardList = Constants.discard_box.instantiate()
	
	dis_box.list = specified_list
	dis_box.stack = from
	return dis_box

func spawn_energy_list(slot: PokeSlot, allowed_fun: Callable = func(card): return true):
	print("WHAT???", slot.energy_cards)
	var energy_dict: Dictionary[Base_Card, bool]
	for card in slot.energy_cards:
		#For some reason duplication doesn't seem to last so I'm duplicating it aghain here
		#Might be fixed in 4.5
		var new_card: Base_Card = card.duplicate(true)
		energy_dict[new_card] = allowed_fun.call(card)
	
	var new_node = Constants.reg_list.instantiate()
	
	new_node.list = energy_dict
	new_node.top_level = true
	new_node.home = operate_home
	new_node.old_pos = slot.ui_slot.global_position
	new_node.stack_act = Constants.STACK_ACT.LOOK
	new_node.stack = Constants.STACKS.NONE
	add_sibling(new_node)
	new_node.header.setup(str(slot.current_card.name, "'s Attatched Energy"))
	Globals.fundies.current_list = new_node

func show_reveal_stack(reveal_slot):
	var stacks = get_stacks(operate_home)
	if stacks.reveal_stack.size() != 0:
		reveal_slot.art.texture = stacks.reveal_stack[-1]
	else:
		reveal_slot.image = null

#endregion
#--------------------------------------

#--------------------------------------
#region TUTORING
func search_array(search: Search, based_on: Array[PokeSlot]) -> Array[Dictionary]:
	var from: Array[Base_Card] = get_stacks(operate_home).get_array(search.where)
	var search_results: Array[Dictionary]
	
	if search.portion != -1:
		from = from.slice(0, search.portion)
	
	if search.and_then.reorder_type != 0:
		pass
	
	for tutor in search.of_this:
		print("--------------------")
		print(tutor)
		print("--------------------")
		search_results.append(identifier_search(from, based_on, tutor))
	
	return search_results

func identifier_search(list: Array[Base_Card], based_on: Array[PokeSlot],\
 identifier: Identifier) -> Dictionary[Base_Card,bool]:
	var valid_dictionary: Dictionary[Base_Card,bool]
	
	for card in list:
		if identifier.identifier_bool(card, based_on):
			valid_dictionary[card] = true
		else: valid_dictionary[card] = false
	
	print("--------------------")
	print("INVALID CARDS: ")
	for card in valid_dictionary: if not valid_dictionary[card]: print(card.name)
	print("--------------------")
	print("--------------------")
	print("VALID CARDS: ")
	for card in valid_dictionary: if valid_dictionary[card]: print(card.name)
	print("--------------------")
	return valid_dictionary

#Redundant for the most part but if it gets the job done
func tutor_instantiate_list(specified_list: Array[Dictionary], search: Search):
	var hand_list: PackedScene = Constants.playing_list
	var new_node = hand_list.instantiate()
	
	new_node.all_lists = specified_list
	new_node.list = specified_list[0]
	new_node.top_level = true
	new_node.instruction_text = "Choose cards to send over"
	new_node.old_pos = Globals.full_ui.player_side.non_mon.stacks[search.where].global_position
	new_node.stack_act = Constants.STACK_ACT.TUTOR
	new_node.stack = search.where
	add_sibling(new_node)
	Globals.fundies.current_list = new_node
	new_node.tutor_component.setup_tutor(search)

func placement_handling(tutored_cards: Array[Base_Card], placement: Placement,\
 origin: Constants.STACKS, untutored_cards: Array[Base_Card]):
	#Is this placement on a stack or on a slot
	#Stack placement
	if placement.which == 0:
		#Does the placement allow these cards to be reordered?
		#Reorder the unchosen cards or chosen cards?
		get_stacks(operate_home).move_cards(tutored_cards, origin, 
		placement.stack, placement.shuffle, placement.top_deck)
	
	#Where are these cards going?
	else: 
		Globals.fundies.card_player.manage_tutored(tutored_cards, placement)
		print()
	
	print(placement.reorder_type)
	#"None", "Reorder Chosen", "Reorder Nonchosen", "Both" reorder_type: int = 0
	if placement.reorder_type != 0:
		if placement.reorder_type != 2:
			var reorder_node = tutor_instantiate_reorder(tutored_cards, placement)
			await SignalBus.reorder_cards
			Globals.control_disapear(reorder_node, .1, reorder_node.old_pos)
		if placement.reorder_type != 1:
			var reorder_node = tutor_instantiate_reorder(untutored_cards, placement)
			await SignalBus.reorder_cards
			Globals.control_disapear(reorder_node, .1, reorder_node.old_pos)

#region REORDERING
func tutor_instantiate_reorder(specified_list: Array[Base_Card], placement: Placement):
	var reorder_list: ReorderList = Constants.reorder_list.instantiate()
	
	reorder_list.list = specified_list
	reorder_list.location = Constants.STACKS.DECK
	reorder_list.placement = placement
	reorder_list.old_pos = Globals.full_ui.player_side.non_mon.stacks[Constants.STACKS.DECK].global_position
	add_sibling(reorder_list)
	
	return reorder_list

func reorder_handling(tutored_cards: Array[Base_Card], origin: Constants.STACKS):
	if origin != Constants.STACKS.DECK:
		print()
	var dict: Dictionary[Constants.STACKS, Array] = get_stacks(operate_home).sendStackDictionary()
	for card in tutored_cards: 
		#Remove all tutored cards from source first
		dict[origin].pop_at(dict[origin].find(card))
	for i in range(tutored_cards.size() - 1, -1, -1):
		dict[origin].push_front(tutored_cards[i])

#endregion

#endregion
#--------------------------------------

#--------------------------------------
#region HELPER FUNCTIONS
func set_operate_home(side: bool):
	operate_home = side

func get_stacks(side: bool) -> CardStacks:
	operate_home = side
	return home_stacks if side else away_stacks

func determine_allowed() -> int:
	var allowed: int = 1023
	
	if first_turn:
		allowed -= 8
	if attatched_energy:
		allowed -= 512
	
	return allowed
#endregion
#--------------------------------------
