extends Button

@export var spawn_position: Vector2 = Vector2(230,25)
@export var benched: bool = false
@export_enum("Left","Right","Up","Down") var spawn_direction: int = 0

@onready var art: TextureRect = %Art
@onready var spawn_offsets: Array[Vector2] = [Vector2(-size.x / 2, 0),
 Vector2(size.x / 2,0), Vector2(0,-size.y / 2), Vector2(0,size.y / 2)]

signal show_attacks
signal show_card

var current_display

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

func spawn_card_display(card: Base_Card, slot: PokeSlot):
	var considered: String = card.card_display()
	var card_display: PackedScene
	var node_tween: Tween = get_tree().create_tween().set_parallel(true)
	match considered:
		"Pokemon": #Pokemon
			card_display = Constants.poke_card
		"Trainer": #Trainers
			card_display = Constants.trainer_card
		"Energy": #Energy
			card_display = Constants.energy_card
		_: #Fossils
			push_error("Fossils not implemented yet")
	
	current_display = card_display.instantiate()
	current_display.top_level = true
	current_display.poke_slot = slot
	current_display.position = global_position
	current_display.scale = Vector2(.05, .05)
	current_display.modulate = Color.TRANSPARENT
	add_child(current_display)
	
	node_tween.tween_property(current_display, "position", spawn_position, .1)
	node_tween.tween_property(current_display, "scale", Vector2.ONE, .1)
	node_tween.tween_property(current_display, "modulate", Color.WHITE, .1)

func despawn_card() -> void:
	var node_tween: Tween = get_tree().create_tween().set_parallel(true)
	
	node_tween.tween_property(current_display, "position", global_position, .1)
	node_tween.tween_property(current_display, "scale", Vector2(.05,.05), .1)
	node_tween.tween_property(current_display, "modulate", Color.TRANSPARENT, .1)
	await node_tween.finished
	
	current_display.queue_free()
