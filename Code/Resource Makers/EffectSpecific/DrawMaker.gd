extends Resource
class_name Draw

@export var shuffle_back_first: bool
@export var side: Constants.SIDES = Constants.SIDES.ATTACKING
##If unchecked it will draw from the top of the deck
@export var bottom_deck: bool = false
##For constant card draws
@export var simple_constant: int = 0
##For variable card draws
@export var counter: Counter
##If an effect is called with this class use the cards drawn as the subject
@export var with_drawn_cards: EffectCall

signal finished

func play_effect():
	print("PLAY DRAW")
	var num_draw = simple_constant
	var old_val = Globals.fundies.stack_manager.operate_home
	Globals.fundies.stack_manager.operate_home = Globals.fundies.get_considered_home(side)
	if counter != null:
		pass
	
	if shuffle_back_first:
		var stack: CardStacks = Globals.fundies.stack_manager.get_stacks(Globals.fundies.get_considered_home(side))
		stack.move_cards(stack.hand, Constants.STACKS.HAND, Constants.STACKS.DECK)
		stack.usable_deck.shuffle()
	
	Globals.fundies.stack_manager.draw(num_draw, not bottom_deck)
	Globals.fundies.stack_manager.operate_home = old_val
	finished.emit()
