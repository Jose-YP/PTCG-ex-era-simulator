@icon("res://Art/Energy/48px-Darkness-attack.png")
extends Control
class_name MimicBox

@export var poke_slot: PokeSlot
@export var attacks: Array[Attack]
@export var show_speed: float = .1

@onready var current_height: float = %Identifier.size.y + 80
@onready var panel_container: PanelContainer = $PanelContainer
@onready var attackScroll: ScrollContainer = %AttackScrollBox

#Gonna use this for mimic
var pay_costs: bool

func _ready():
	%AttackScrollBox.pay_costs = pay_costs
	%AttackScrollBox.reset_items()
	%AttackScrollBox.set_specific_items(attacks)

func _draw():
	await get_tree().process_frame
	var list_tween: Tween = get_tree().create_tween().set_parallel()
	current_height += %AttackScrollBox.current_height
	
	current_height = clamp(current_height, current_height, 400)
	list_tween.tween_property(self, "modulate", Color.WHITE, show_speed)
	list_tween.tween_property(panel_container, "size", Vector2(0, current_height), show_speed * 1.5)

# Called when the node enters the scene tree for the first time.
func reset_items():
	var list_tween: Tween = get_tree().create_tween().set_parallel()
	%AttackScrollBox.reset_items()
	
	list_tween.tween_property(self, "modulate", Color.TRANSPARENT, show_speed)
	list_tween.tween_property(self, "scale", Vector2(.1,.1), show_speed)
	list_tween.tween_property(panel_container, "size", Vector2(0, 0), show_speed * 2)
	
	await list_tween.finished
	queue_free()
