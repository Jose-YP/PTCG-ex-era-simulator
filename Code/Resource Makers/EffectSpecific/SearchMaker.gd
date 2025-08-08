extends Resource
class_name Search

##Which section will the player search (yes there is defender searching)
@export var side: Consts.SIDES = Consts.SIDES.SOURCE
@export var where: Consts.STACKS = Consts.STACKS.DECK
@export var reordering_only: bool = false
@export var shuffle_first: bool = false
##Will the identifier base it's results on anything?
@export var based_on_side: Consts.SIDES
@export var based_on_slots: Consts.SLOTS
@export_enum("None","Shown", "Attatched") var based_on_energy: int = 0
##How many cards in the desired section can you check.
##-1 means all cards. For certain cards that look at a bit of the top of the deck.
@export_range(-1,60, 1) var portion: int = -1
## -1 mean all. How many identifiers are you allowed to tutor from at a time
## ex. if this is 1 then you can only tutor from 1 identifier no matter how many there actually are
@export_range(-1,10,1) var identifier_allowed: int = -1
#holon Lass uses a varying portion based on prize cards soooo
@export var variable_portion: Comparator
##How many cards can the user pick, if it's -1 allow infinite
@export var how_many: Array[int] = [1]
##Incase of variable search ammounts
@export var variable_ammount: Comparator
##For each item in identifier, search how_many
@export var of_this: Array[Identifier]
##Where do the tutored cards go?
@export var and_then: Placement = preload("res://Resources/Components/Effects/Placement/PutIntoHand.tres")
##Should the defender see any of these cards?
@export var reveal: bool = true

signal finished

func play_effect(reversable: bool = false, replace_num: int = -1) -> void:
	print("PLAY SEARCH")
	var based_on_cards: Array[PokeSlot]
	var stack_mana: StackManager = Globals.fundies.stack_manager
	if based_on_side != 0 and based_on_slots != 0:
		based_on_cards = Globals.fundies.get_poke_slots(based_on_side, based_on_slots)
		print("BASED ON ", based_on_side, based_on_slots, based_on_cards)
	
	var search_for: Array[Dictionary] = stack_mana.search_array(self, based_on_cards)
	if reordering_only and and_then.reorder_type != 0:
		stack_mana.tutor_instantiate_reorder(search_for[0].keys(), and_then)
		await SignalBus.reorder_cards
	else:
		stack_mana.tutor_instantiate_list(search_for, self)
		await SignalBus.swap_card_location
	
	await and_then.finished
	
	finished.emit()
