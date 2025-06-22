extends Resource
class_name PromptAsk

##Give a prompt asking to activate the effect?
@export var formal_ask: bool = false
##For booleans, Seperate it with ||
@export_multiline var ask_string: String 
##If there's a coin flip, check if it passes[br]
##Succesful coin flips allow for succesful effects and coin reliant dmg
@export var coin_flip: CoinFlip
@export var counter: Counter
@export var side: Constants.SIDES = Constants.SIDES.ATTACKING

@export_flags("Bench", "Active", "Self", 
"Discard", "Hand", "Desicion") var choose_location: int = 0

##These must be performed before doing the proceeding effect/attack
@export var effect: EffectCall
