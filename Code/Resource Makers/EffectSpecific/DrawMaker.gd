extends Resource
class_name Draw

@export var side: Constants.SIDES = Constants.SIDES.ATTACKING
##If unchecked it will draw from the top of the deck
@export var bottom_deck: bool = false
##For constant card draws
@export var simple_constant: int = 0
##For variable card draws
@export var counter: Counter
##If an effect is called with this class use the cards drawn as the subject
@export var with_drawn_cards: EffectCall

func play_effect(fundies: Fundies):
	print("PLAY DRAW")
