extends Button

#--------------------------------------
#region VARIABLES
@export var pokemon: bool = true
@export var spawn_position: Vector2 = Vector2(230,25)
@export var benched: bool = false
@export_enum("Left","Right","Up","Down") var spawn_direction: int = 0

@onready var art: TextureRect = %Art
@onready var spawn_offsets: Array[Vector2] = [Vector2(-size.x / 2, 0),
 Vector2(size.x / 2,0), Vector2(0,-size.y / 2), Vector2(0,size.y / 2)]

var connected_ui: UI_Slot

var current_card: Base_Card:
	set(value):
		current_card = value
		disabled = value == null
		if value != null:
			%Art.texture = value.image
			var art_tween: Tween = create_tween().set_parallel()
			art.scale = Vector2.ZERO
			art_tween.tween_property(%Art, "scale", Vector2.ONE, .1)
		else:
			%Art.texture = null
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
	if event.is_action_pressed("A") and not disabled:
		if current_card:
			Globals.show_card(current_card, self)
		else:
			SignalBus.chosen_slot.emit(connected_ui.connected_slot)

func _on_pressed() -> void:
	if pokemon:
		SignalBus.chosen_slot.emit(owner.connected_slot)
#endregion
#--------------------------------------
