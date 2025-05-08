extends Node2D

@export var deck1: Deck
@export var deck2: Deck

enum side{PLAYER, OPPONENT}

var mulligans: Dictionary = {"Player": 0, "Opponent": 0}
var sides_ready: Array = [false, false]
var starting_side: side

func _ready():
	%ResourcesPlay.assign_deck(deck1)
	%ResourcesOpp.assign_deck(deck2)
	draw_starting(side.PLAYER)

func draw_starting(from: side):
	if from == side.PLAYER:
		%ResourcesPlay.draw(7 + mulligans["Player"])
		print("----------PLAYER---------")
		%ResourcesPlay.check_starting()
		#sides_ready[0] = true
	else:
		%ResourcesOpp.draw(7 + mulligans["Opponent"])
		print("----------OPPONENT---------")
		%ResourcesOpp.check_starting()
		#sides_ready[0] = true
