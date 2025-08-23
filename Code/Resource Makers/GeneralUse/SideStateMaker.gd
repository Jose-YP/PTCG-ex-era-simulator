extends Resource
class_name SideState

@export var card_stacks: CardStacks
@export var prize_cards: int = 6
@export var bench_size: int = 5
##The boolean will determine whether or not a slot is active or not
##[br] take these cards inside slots from deck if [member home_UD] is null
@export var slots: Dictionary[PokeSlot, bool]
@export var inital_supporter: Base_Card

func duplicate_deep() -> SideState:
	var copy: SideState = self.duplicate(true)
	if inital_supporter:
		inital_supporter = inital_supporter.duplicate_deep()
	
	copy.slots = {}
	
	for slot in slots:
		copy.slots[slot.duplicate_deep()] = slots[slot]
	
	return copy
