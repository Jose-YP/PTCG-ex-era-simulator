@icon("res://Art/ProjectSpecific/cards.png")
extends Resource
class_name CardStacks

#--------------------------------------
#region VARIABLES
@export var deck: Deck
##If this is true then the cards exluded from [member init_deck] get put on the discard
##[br] otherwise they end up behind [member init_deck]
@export var excluded_to_discard: bool
##This should only be filled in for cases where usable deck starts at less than 60
@export var init_deck: Array[Base_Card] = []
##This should only be filled in for cases where the user always starts with certian cards
##[br] if [member usable_deck] is null, take these cards from the [member deck]
@export var init_hand: Array[Base_Card] = []
@export var init_discard: Array[Base_Card] = []
@export var init_prize: Array[Base_Card] = []
@export_category("During Play")
var discard_pile: Array[Base_Card] = []
var prize_cards: Array[Base_Card] = []
var usable_deck: Array[Base_Card] = []
var hand: Array[Base_Card] = []
#Here in case they need to be used at some point
var reveal_stack: Array[Base_Card]
var cards_in_play: Array[Base_Card]
var lost_zone: Array[Base_Card]
#endregion
#--------------------------------------

#--------------------------------------
#region INITALIZATION
func make_deck():
	usable_deck = deck.make_usable()
	if usable_deck.size() != 60: printerr("Deck isn't thre right size ", usable_deck.size())
	#for card in usable_deck:
		#printt(card.name, Consts.expansion_abbreviations[card.expansion], card.number)
	
	usable_deck.shuffle()
	init_sync(init_deck)
	init_sync(init_hand)
	init_sync(init_discard)
	init_sync(init_prize)
	move_cards(init_hand, Consts.STACKS.DECK, Consts.STACKS.HAND)
	move_cards(init_discard, Consts.STACKS.DECK, Consts.STACKS.DISCARD)
	move_cards(init_prize, Consts.STACKS.DECK, Consts.STACKS.PRIZE)

func setup():
	if init_deck.size() != 0 and excluded_to_discard:
		move_cards(usable_deck, Consts.STACKS.DECK, Consts.STACKS.DISCARD)
		move_cards(init_deck, Consts.STACKS.DISCARD, Consts.STACKS.DECK)
	else:
		for card in init_deck:
			if usable_deck.find_custom(card.same_card) == -1:
				printerr("Can't find ", card.get_formal_name(), " on setup")
		
		usable_deck.sort_custom(func(card_a: Base_Card, card_b: Base_Card):\
			 return init_deck.find_custom(card_a.same_card)\
			> init_deck.find_custom(card_b.same_card))

func account_for_slot(slot: PokeSlot):
	init_remove_deck(slot.current_card)
	if slot.tool_card:
		init_remove_deck(slot.tool_card)
	for card in slot.energy_cards:
		init_remove_deck(card)
	for card in slot.tm_cards:
		init_remove_deck(card)
	for card in slot.evolved_from:
		init_remove_deck(card)

func init_remove_deck(card: Base_Card):
	if usable_deck.find_custom(card.same_card) == -1:
		printerr("Can't find ", card.get_formal_name(), " on init_remove_deck")
	usable_deck.remove_at(usable_deck.find_custom(card.same_card))
	#usable_deck.erase(card)
	cards_in_play.append(card)

func init_sync(list: Array[Base_Card]):
	for card in list:
		var index: int = usable_deck.find_custom(card.same_card)
		if index != -1:
			card = usable_deck[index]

#endregion
#--------------------------------------

#--------------------------------------
#region DURING PLAY
func sendStackDictionary() -> Dictionary[Consts.STACKS, Array]:
	return {
 Consts.STACKS.HAND: hand, Consts.STACKS.DECK: usable_deck,
 Consts.STACKS.DISCARD: discard_pile, Consts.STACKS.PRIZE: prize_cards,
 Consts.STACKS.PLAY: cards_in_play, Consts.STACKS.LOST: lost_zone}

func append_to_arrays(type: Consts.STACKS, card: Base_Card, top_deck: bool = false):
	#Consts.STACKS.DECK and bottom_stack
	match type:
		Consts.STACKS.HAND:
			hand.append(card)
		Consts.STACKS.DECK:
			if top_deck: #This is generally slower so only when top deck is important
				usable_deck.push_front(card)
			else:
				usable_deck.append(card)
			
		Consts.STACKS.DISCARD:
			discard_pile.append(card)
		Consts.STACKS.PRIZE:
			prize_cards.append(card)
		Consts.STACKS.PLAY:
			cards_in_play.append(card)
		Consts.STACKS.LOST:
			lost_zone.append(card)
		_:
			push_error(type, " is not in ", self)
			hand.append(card)

func get_array(type: Consts.STACKS) -> Array[Base_Card]:
	match type:
		Consts.STACKS.HAND:
			return hand
		Consts.STACKS.DECK:
			return usable_deck
		Consts.STACKS.DISCARD:
			return discard_pile
		Consts.STACKS.PRIZE:
			return prize_cards
		_:
			push_error(type, " is not in ", self)
			return hand

func none_lost() -> bool:
	var total: int = (usable_deck.size() + discard_pile.size() + hand.size()
	 + prize_cards.size() + cards_in_play.size() + lost_zone.size())
	if total != 60:
		printt(usable_deck.size(),  discard_pile.size(), hand.size(), prize_cards.size(),
		cards_in_play.size(), lost_zone.size(), total)
		printerr("We lost someone")
	
	return total == 60

func move_cards(cards: Array[Base_Card], from: Consts.STACKS, towards: Consts.STACKS,
 shuffle: bool = true, top_deck: bool = false):
	var dict: Dictionary[Consts.STACKS, Array] = sendStackDictionary()
	for i in range(cards.size() - 1, -1, -1):
		var card: Base_Card = cards[i]
		#Remove all tutored cards from source first
		#var adding_card = dict[from].pop_at(dict[from].find_custom(card.same_card))
		var adding_card: Base_Card = dict[from][dict[from].find_custom(card.same_card)]
		if not card.same_card(adding_card):
			for c in dict[from]: print(c.name)
			print(dict[from].find_custom(card.same_card))
			printerr(card.name, " is not the same as ", adding_card.name)
		dict[from].erase(adding_card)
		#Now it can be added back to the towards array
		append_to_arrays(towards, adding_card, top_deck)
	
	#The deck is the only one that needs to be shuffled
	if (from == Consts.STACKS.DECK or towards == Consts.STACKS.DECK) and shuffle:
		usable_deck.shuffle()
	else:
		print(Convert.stack_into_string(from), Convert.stack_into_string(towards), shuffle)
	
	none_lost()

#endregion
#--------------------------------------
func identifier_search(list: Consts.STACKS, identifier: Identifier,\
based_on: Array[PokeSlot] = [], portion: int = -1) -> Dictionary[Base_Card,bool]:
	var valid_dictionary: Dictionary[Base_Card,bool]
	var using: Array[Base_Card] = get_array(list)
	
	if portion != -1:
		using = using.slice(0, portion)
	
	for card in using:
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
