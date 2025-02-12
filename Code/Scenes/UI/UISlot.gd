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

func display_energy(_energy: Dictionary):
	pass
