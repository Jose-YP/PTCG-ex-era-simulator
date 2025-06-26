extends Button

#--------------------------------------
#region VARIABLES
@export var pokemon: bool = true
@export var spawn_position: Vector2 = Vector2(230,25)
@export var benched: bool = false
@export_enum("Left","Right","Up","Down") var spawn_direction: int = 0

@onready var art: TextureRect = %Art
@onready var image: CompressedTexture2D = %Art.texture:
	set(value):
		%Art.texture = value
		print(disabled, value == null)
		disabled = value == null
		if value != null:
			var art_tween: Tween = create_tween().set_parallel()
			art.scale = Vector2.ZERO
			art_tween.tween_property(%Art, "scale", Vector2.ONE, .1)
@onready var spawn_offsets: Array[Vector2] = [Vector2(-size.x / 2, 0),
 Vector2(size.x / 2,0), Vector2(0,-size.y / 2), Vector2(0,size.y / 2)]

#signal show_attacks
signal show_card

var current_display
#endregion
#--------------------------------------

#--------------------------------------
#region INITALIZATION & PROCESSING
func _ready():
	get_child(0).size = %ArtButton.size
	if benched: 
		custom_minimum_size = Vector2(149, 96)
		art.custom_minimum_size = Vector2(142, 87)
		art.position = Vector2(4,3)

# Called when the node enters the scene tree for the first time.
func _gui_input(event):
	if event.is_action_pressed("Check"):
		show_card.emit()
#endregion
#--------------------------------------

#--------------------------------------
#region PRESSED BUTTON
func _on_pressed() -> void:
	if pokemon:
		SignalBus.chosen_slot.emit(owner.connected_slot)

func handle_card_display(card: Base_Card, slot):
	if current_display:
		despawn_card()
	else:
		spawn_card_display(card, slot)

func spawn_card_display(card: Base_Card, slot):
	if current_display: return
	
	var considered: String = card.card_display()
	var node_tween: Tween = get_tree().create_tween().set_parallel(true)
	match considered:
		"Pokemon": #Pokemon
			current_display = Constants.poke_card.instantiate()
		"Trainer": #Trainers
			current_display = Constants.trainer_card.instantiate()
		"Energy": #Energy
			current_display = Constants.energy_card.instantiate()
		_: #Fossils
			push_error("Fossils not implemented yet")
	
	current_display.card = slot.current_card
	current_display.top_level = true
	current_display.position = global_position
	current_display.scale = Vector2(.05, .05)
	current_display.modulate = Color.TRANSPARENT
	add_child(current_display)
	
	node_tween.tween_property(current_display, "position", spawn_position, .1)
	node_tween.tween_property(current_display, "scale", Vector2.ONE, .1)
	node_tween.tween_property(current_display, "modulate", Color.WHITE, .1)

func despawn_card() -> void:
	if not current_display: return
	
	var node_tween: Tween = get_tree().create_tween().set_parallel(true)
	
	node_tween.tween_property(current_display, "position", global_position, .1)
	node_tween.tween_property(current_display, "scale", Vector2(.05,.05), .1)
	node_tween.tween_property(current_display, "modulate", Color.TRANSPARENT, .1)
	await node_tween.finished
	
	current_display.queue_free()
#endregion
#--------------------------------------
