extends Button

@export var benched: bool = false

@onready var art: TextureRect = %Art

signal show_attacks
signal show_card

func _ready():
	if benched: 
		custom_minimum_size = Vector2(149, 96)
		art.custom_minimum_size = Vector2(142, 87)

# Called when the node enters the scene tree for the first time.
func _gui_input(event):
	if event.is_action_pressed("A"):
		show_attacks.emit()
		print('eron')
	elif event.is_action_pressed("L"):
		show_card.emit()
		print('onf')
	

func spawn_card_display(card: Base_Card, considered):
	var card_display: PackedScene
	match considered:
		0: #Pokemon
			card_display = Constants.poke_card
		1: #Trainers
			card_display = Constants.trainer_card
		2: #Energy
			card_display = Constants.energy_card
		_: #Fossils
			push_error("Fossils not implemented yet")
	
	var node = card_display.instantiate()
	
