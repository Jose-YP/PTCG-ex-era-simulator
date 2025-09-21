@icon("res://Art/Energy/35px-Rainbow-attack.png")
extends Control
class_name TypeContainer

@export var retreat: bool = false
@export var energy: bool = false
@onready var bg: TextureRect = $PanelContainer/BG

var number: int = 0

func _ready(): if retreat: $Tabs.current_tab = 8

func add_type(type: String, ammount: int = 1):
	number = ammount
	display_type(type)
	
	$Number.clear()
	$Number.append_text(str(number))
	
	if number >= 1: show()
	if number > 1: $Number.show()
	else:
		$Number.hide()

func display_type(type: String):
	var type_id: int = Consts.energy_types.find(type)
	$Tabs.current_tab = type_id
	#Special types
	#const energy_types: Array[String] = [8+ "Rainbow", "Magma",
	#"Aqua", "Dark Metal","FF", "GL", "WP", "React"]
	if type_id < 10 or type_id > 12:
		bg.modulate = Consts.energy_colors[type_id]
	elif type_id < 14:
		bg.modulate = Consts.energy_colors[6]

func remove_type():
	number -= 1
	$Number.clear()
	$Number.append_text(str(number))
	
	if number <= 1: $Number.hide()
	if number < 1: hide()

func make_misc(ammount: int) -> void:
	number = ammount
	$Tabs.current_tab = $Tabs.get_tab_count() - 1
	
	$Number.clear()
	$Number.append_text(str(number))
	
	if number <= 1: $Number.hide()
	if number < 1: hide()

func get_type_index() -> int:
	return $Tabs.current_tab
