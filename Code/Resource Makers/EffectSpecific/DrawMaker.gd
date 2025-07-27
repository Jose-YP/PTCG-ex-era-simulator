extends Resource
class_name Draw

@export var shuffle_back_first: bool
@export var side: Consts.SIDES = Consts.SIDES.ATTACKING
##If unchecked it will draw from the top of the deck
@export var bottom_deck: bool = false
##For constant card draws
@export var simple_constant: int = 0
##For variable card draws
@export var comparator: Comparator
##If an effect is called with this class use the cards drawn as the subject
@export var with_drawn_cards: EffectCall

signal finished

func play_effect(reversable: bool = false, replace_num: int = -1) -> void:
	print("PLAY DRAW")
	var num_draw = simple_constant
	var old_val = Globals.fundies.stack_manager.operate_home
	Globals.fundies.stack_manager.operate_home = Globals.fundies.get_considered_home(side)
	if comparator != null:
		pass
	
	if shuffle_back_first:
		Globals.fundies.stack_manager.shuffle_hand_back()
	
	Globals.fundies.stack_manager.draw(num_draw, not bottom_deck)
	Globals.fundies.stack_manager.operate_home = old_val
	finished.emit()
