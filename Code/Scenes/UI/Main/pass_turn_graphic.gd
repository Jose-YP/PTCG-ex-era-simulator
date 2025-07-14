extends Control

@onready var color_rect: ColorRect = %ColorRect
@onready var turn_graphic: TabContainer = %TurnGraphic
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func turn_change():
	if Globals.fundies.home_turn:
		turn_graphic.current_tab = 0
	else:
		turn_graphic.current_tab = 1
	
	animation_player.play("TurnChange")
