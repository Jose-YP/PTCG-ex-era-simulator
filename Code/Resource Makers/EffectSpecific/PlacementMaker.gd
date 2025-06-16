extends Resource
class_name Placement

@export_category("Location")
##Will the chosen cards be placed in a stack or in a pokeslot
@export_enum("Stack", "Slot") var which: int = 0
##This variable dtermines where deck placements should go[br]
##Keep this as false if the deck is going to be shuffled regardless
@export var top_deck: bool = false
@export var stack: Constants.STACKS = Constants.STACKS.DECK
##What choices does the user have when placing in slots
@export var slot: Constants.SLOTS = Constants.SLOTS.ALL

@export_group("And then")
#Might not be necessary
@export_flags("Basic", "Evolution", 
"Item", "Supporter","Stadium", "Tool", "TM", "RSM",
 "Fossil", "Energy") var use_as: int = 0

##Which cards are sent to be reoerdered?
@export_enum("None", "Reorder Chosen", "Reorder Nonchosen", "Both") var reorder_type: int = 0
@export var shuffle: bool = true
##Apply the effects of evolution on this card,
##otherwise it'll just swap current card
@export var evolve: bool = false
@export var effect_to_mon: EffectCall

func reordering():
	pass

#If an action places a card on a slot, determine how that works out
func determine_action(fundies: Fundies, card: Base_Card):
	var usage: int = Conversions.get_card_flags(card)
	
	#For basics
	if usage && 1 or usage && 256 or usage && 2 and not evolve:
		pass
	#If evolution
	elif usage && 2 and evolve:
		pass
	#If stadium
	elif usage && 16:
		pass
	#If Tool
	elif usage && 32:
		pass
	#If TM
	elif usage && 64:
		pass
	#If energy
	elif usage && 512:
		pass
	#For all else
	else:
		pass
