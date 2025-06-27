extends Resource
class_name Disable

#@export_group("Disable")
@export var side: Constants.SIDES = Constants.SIDES.DEFENDING
@export var slot: Constants.SLOTS = Constants.SLOTS.ALL
@export var ask: SlotAsk
##-1 means ignore duration, check a prompt/ask to see if the effect should continue
##[br]-2 means forever, no conditions need to be checked afterwards
##[br]otherwise the effect lasts for this many turns 
@export var duration: int = -1
@export var no_weakness: bool = false
@export var no_resistance: bool = false
@export var instead_of_damage: bool = false
@export var do_nothing: bool = false
##Can - Change nothing on the target's attacking ability
##[br]Flip - Target must now win a coinflip to attack
##[br]Can't - Target cannot attack
@export_enum("Can", "Flip", "Can't") var attack: int = 0
@export_enum("Can", "Flip", "Can't") var power: int = 0
@export_subgroup("Retreat")
##-1 means forever, otherwise it's turn duration
@export var retreat_duration: int = 1
@export var disable_retreat: bool = false

func play_effect():
	print("PLAY DISABLE")
