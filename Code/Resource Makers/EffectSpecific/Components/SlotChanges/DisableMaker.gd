@icon("res://Art/ProjectSpecific/disabled.png")
extends SlotChange
class_name Disable

@export_group("Side Functions")
@export var card_type: Identifier
@export_group("Mon Functions")
@export var disable_power: bool = false
@export var disable_body: bool  = false
@export var disable_retreat: bool = false
@export_group("Attack")
##If this isn't -1, then the user must choose x ammount of attacks to disable,
##[br]if they have that many or less then disable all
@export var choose_num: int = -1
##[enum]Can[/enum] - Change nothing on the target's attacking ability
##[br][enum]Flip[/enum] - Target must now win a coinflip to attack
##[br][enum]Cant[/enum] - Target cannot attack
@export var attack: DIS_STATUS = DIS_STATUS.CAN
##If this is disabled it should be false
@export var atk_effect: bool = true
##If this is filled with anything the disable will only work on specified attacks
@export var attack_names: Array[String]

enum DIS_STATUS {CAN, CANT, FLIP}

func play_effect(reversable: bool = false, replace_num: int = -1) -> void:
	print("PLAY DISABLE")
	
	finished.emit()
