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
	
