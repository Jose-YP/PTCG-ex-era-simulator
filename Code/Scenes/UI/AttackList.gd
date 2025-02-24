extends Control

@export var attackItem: PackedScene
@export var powerItem: PackedScene
@export var bodyItem: PackedScene
@export var current_slot: PokeSlot
@export var current_card: Base_Card
@export var max_size: Vector2 = Vector2(420, 400)
@export var show_speed: float = .1

@onready var current_height: float = %Identifier.size.y + 25
@onready var panel_container: PanelContainer = $PanelContainer

var items: Array[Node] = []
var display_text: String = ""
var final_size: int = 0
var attacks: Array[Attack] = []
var power: PokePower
var body: PokeBody

func _ready():
	#So it can be sued on a poke slot or not
	attacks = (current_slot.pokedata.attacks if current_slot 
	else current_card.pokemon_properties.attacks)
	
	power = (current_slot.pokedata.power if current_slot 
	else current_card.pokemon_properties.power)
	
	body = (current_slot.pokedata.body if current_slot 
	else current_card.pokemon_properties.body)
	
	set_items()

# Called when the node enters the scene tree for the first time.
func reset_items():
	var list_tween: Tween = get_tree().create_tween().set_parallel()
	for item in items:
		item.queue_free()
	
	list_tween.tween_property(self, "modulate", Color.TRANSPARENT, show_speed)
	list_tween.tween_property(self, "scale", Vector2(.1,.1), show_speed)
	list_tween.tween_property(panel_container, "size", Vector2(0, 0), show_speed * 2)
	
	await list_tween.finished
	queue_free()

func set_items():
	#Get PokeBody
	if body:
		var body_making = bodyItem.instantiate()
		body_making.body = body
		%CardList.add_child(body_making)
		current_height += body_making.size.y
	
	#Get Pokepower
	if power:
		var power_making = powerItem.instantiate()
		power_making.power = power
		%CardList.add_child(power_making)
		current_height += power_making.size.y
	
	var list_tween: Tween = get_tree().create_tween().set_parallel()
	for item in attacks:
		var making = attackItem.instantiate()
		making.attack = item
		%CardList.add_child(making)
		if current_slot: #only try this when attatched to a pokeslot
			making.check_usability(current_slot.energy_array)
		print(item.name, making.size.y)
		current_height += making.size.y
	
	items = %CardList.get_children()
	
	current_height = clamp(current_height, current_height, max_size.y)
	list_tween.tween_property(self, "modulate", Color.WHITE, show_speed)
	list_tween.tween_property(self, "scale", Vector2(1,1), show_speed)
	list_tween.tween_property(panel_container, "size", Vector2(0, current_height), show_speed * 2)
	
	panel_container.size.y = current_height
