extends Control

@export var attackItem: PackedScene
@export var card: Base_Card
@export var max_size: Vector2 = Vector2(420, 600)
@export var show_speed: float = .1

@onready var attacks: Array[Attack] = card.pokemon_properties.attacks
@onready var current_height: int = %Identifier.size.y + 5
@onready var panel_container: PanelContainer = $PanelContainer

var items: Array[Node] = []
var display_text: String = ""
var cursor: TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	set_items(true)

func reset_items():
	var list_tween: Tween = get_tree().create_tween().set_parallel()
	for item in items:
		item.queue_free()
	
	if cursor:
		cursor.point_options.clear()
		cursor.queue_free()
	
	list_tween.tween_property(self, "modulate", Color.TRANSPARENT, show_speed)
	list_tween.tween_property(self, "scale", Vector2(.1,.1), show_speed)
	list_tween.tween_property(panel_container, "size", Vector2(0, 0), show_speed * 2)
	
	await list_tween.finished
	queue_free()

func set_items(can_select):
	var list_tween: Tween = get_tree().create_tween().set_parallel()
	for item in attacks:
		var making = attackItem.instantiate()
		making.attack = item
		%CardList.add_child(making)
		current_height += making.size.y
	
	items = %CardList.get_children()
	
	current_height = clamp(current_height, current_height, max_size.y)
	list_tween.tween_property(self, "modulate", Color.WHITE, show_speed)
	list_tween.tween_property(self, "scale", Vector2(1,1), show_speed)
	list_tween.tween_property(panel_container, "size", Vector2(0, current_height), show_speed * 2)
	
	$PanelContainer.size.y = current_height
	
	if can_select:
		cursor = Constants.cursor.instantiate()
		cursor.pointing_at = items[0]
		print(items, cursor.point_options)
		cursor.point_options.append(items)
		
		add_child(cursor)
		cursor.moving = true
		cursor.set_arrow_position()
