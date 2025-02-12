extends Control
class_name UI_Slot
@export_enum("Active", "Bench") var slot_type: int = 1

@onready var name_section: RichTextLabel = %Name
@onready var max_hp: RichTextLabel = %MaxHP
@onready var art: TextureRect = %Art
@onready var tool: TextureRect = %Tool
@onready var tm: TextureRect = %TM
@onready var imprison = %Imprison
@onready var shockwave: TextureRect = %Shockwave
@onready var typeContainer: Array[Node] = %TypeContainer.get_children()
@onready var energyContainer: Array[Node] = %EnergyTypes.get_children()

signal pressed_slot

#Unfinished, doesn't account for special energy
var attached_energy: Dictionary = {"Grass": 0, "Fire": 0, "Water": 0,
 "Lightning": 0, "Psychic":0, "Darkness":0, "Metal":0, "Colorless":0,
 "Rainbow":0, "Magma":0, "Aqua":0, "Dark Metal":0, "React": 0,
 "Holon FF": 0, "Holon GL": 0, "Holon WP": 0}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func display_types(types: Array[String]):
	for node in typeContainer:
		node.hide()
	
	for i in range(types.size()):
		typeContainer[i].display_type(types[i])
		typeContainer[i].show()

func display_energy(energy_arr: Array, energy_dict: Dictionary):
	for node in energyContainer:
		node.hide()
		node.number = 0
	
	if energy_arr.size() > energyContainer.size():
		print("COMPRESSED ADD")
		var total_types: int = 0
		for type in energy_dict:
			if energy_dict[type] > 0:
				energyContainer[total_types].add_type(type, energy_dict[type])
				total_types += 1
	else:
		print("REGULAR ADD")
		for i in range(energy_arr.size()):
			print("ADD", energy_arr[i])
			energyContainer[i].add_type(energy_arr[i])
	

func pressed_a_slot():
	pressed_slot.emit()
