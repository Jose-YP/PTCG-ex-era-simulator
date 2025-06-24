@icon("res://Art/ProjectSpecific/alpha.png")
extends Control
class_name BoardNode

@export var board_state: BoardState
@export var player_side: CardSideUI
@export var opponent_side: CardSideUI
@export var fundies: Fundies

func _ready() -> void:
	for slot in board_state.home_slots:
		print(slot)
		if board_state.home_slots[slot]:
			pass
		else:
			pass
