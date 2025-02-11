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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display_types(types: Array[String]):
	for node in typeContainer:
		node.hide()
	
	for i in range(types.size()):
		typeContainer[i].display_type(types[i])
		typeContainer[i].show()

func display_energy(_energy: Dictionary):
	pass
