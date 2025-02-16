extends Control
class_name UI_Slot
@export var active: bool = true
@export_enum("Left","Right","Up","Down") var list_direction: int = 0
@export var attack_list: PackedScene

@onready var name_section: RichTextLabel = %Name
@onready var max_hp: RichTextLabel = %MaxHP
@onready var art: TextureRect = %Art
@onready var tool: TextureRect = %Tool
@onready var tm: TextureRect = %TM
@onready var imprison = %Imprison
@onready var shockwave: TextureRect = %Shockwave
@onready var typeContainer: Array[Node] = %TypeContainer.get_children()
@onready var energyContainer: Array[Node] = %EnergyTypes.get_children()
@onready var list_offsets: Array[Vector2] = [Vector2(-size.x / 2, 0),
 Vector2(size.x / 2,0), Vector2(0,-size.y / 2), Vector2(0,size.y / 2)]

signal pressed_slot

#Unfinished, doesn't account for special energy
var connected_card: PokeSlot
var attached_energy: Dictionary = {"Grass": 0, "Fire": 0, "Water": 0,
 "Lightning": 0, "Psychic":0, "Darkness":0, "Metal":0, "Colorless":0,
 "Rainbow":0, "Magma":0, "Aqua":0, "Dark Metal":0, "React": 0,
 "Holon FF": 0, "Holon GL": 0, "Holon WP": 0}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func spawn_attacks() -> Control:
	var list = Constants.attack_list.instantiate()
	list.current_slot = connected_card
	list.position = position + list_offsets[list_direction]
	print(get_parent())
	get_parent().add_child(list)
	return list

#--------------------------------------
#region ATTATCH
func attatch_tool(tool_card: Base_Card):
	if tool_card:
		tool.show()
		tool.texture = tool_card.image

func attatch_tms(tms: Array[Base_Card]):
	tm.hide()
	
	if tms.size() > 0: #Show the latest attatched
		tm.show()
		tm.texture = tms[-1].image
	
	if tms.size() > 1:
		tm.get_child(0).show()
	else:
		tm.get_child(0).hide()

#endregion
#--------------------------------------

#--------------------------------------
#region ENERGY DISPLAY
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
#endregion
#--------------------------------------

#--------------------------------------
#region CONDITION DISPLAY
func display_condition() -> void:
	if connected_card.poison_condition != 0:
		%Poison.show()
	elif active: %Poison.hide()
	
	if connected_card.burn_condition != 0:
		%Burn.show()
	elif active: %Burn.hide()
	
	if connected_card.turn_condition != 0:
		%TurnConditions.show()
		%TurnConditions.current_tab = connected_card.turn_condition - 1

	elif active: %TurnConditions.hide()

func display_imprision(truth: bool = true) -> void:
	if truth: %Imprison.show()
	else: %Imprison.hide()

func display_shockwave(truth: bool = true) -> void:
	if truth: %Shockwave.show()
	else: %Shockwave.hide()

#endregion
#--------------------------------------

#--------------------------------------
#region SIGNALS
func pressed_a_slot():
	print("OLDSCJANNJOKASILDCJNIKALDSNJASKDCLU")
	pressed_slot.emit()
#endregion
#--------------------------------------
