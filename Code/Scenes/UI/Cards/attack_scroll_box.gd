extends ScrollContainer

@export var check: bool = true
@export var attackItem: PackedScene
@export var powerItem: PackedScene
@export var bodyItem: PackedScene
@export var poke_slot: PokeSlot
@export var current_card: Base_Card
@export var max_size: Vector2 = Vector2(420, 400)

@onready var current_height: float = 55

signal readied(current_size)

var resized_container: bool = false
var items: Array[Node] = []
var display_text: String = ""
var final_size: int = 0
var attacks: Array[Attack] = []
var power: PokePower
var body: PokeBody

func _ready() -> void:
	#So it can be sued on a poke slot or not
	attacks = (poke_slot.get_pokedata().attacks if poke_slot 
	else current_card.pokemon_properties.attacks)
	
	power = (poke_slot.get_pokedata().power if poke_slot 
	else current_card.pokemon_properties.power)
	
	body = (poke_slot.get_pokedata().body if poke_slot 
	else current_card.pokemon_properties.body)
	
	set_items()
	size_default()

#Once every item is readied, wait before seeking final size
func _draw():
	await get_tree().process_frame
	if not resized_container:
		for item in items:
			current_height += item.size.y
		
		current_height = clamp(current_height, current_height, max_size.y)
		size.y = current_height
		resized_container = true
		readied.emit(current_height)

# Called when the node enters the scene tree for the first time.
func reset_items() -> void:
	for item in items:
		item.queue_free()

func set_items() -> void:
	#Get PokeBody
	if body:
		var body_making = bodyItem.instantiate()
		body_making.body = body
		if check: body_making.focus_mode = FocusMode.FOCUS_NONE
		%CardList.add_child(body_making)
	
	#Get Pokepower
	if power:
		var power_making = powerItem.instantiate()
		power_making.power = power
		if check: power_making.focus_mode = FocusMode.FOCUS_NONE
		%CardList.add_child(power_making)
	
	for item in attacks:
		var making = attackItem.instantiate()
		making.attack = item
		making.slot = poke_slot
		%CardList.add_child(making)
		if check: making.focus_mode = FocusMode.FOCUS_NONE
		if poke_slot: #only try this when attatched to a pokeslot
			making.check_usability()
	
	items = %CardList.get_children()

func size_default() -> void:
	size = Vector2(max_size.x, current_height)
