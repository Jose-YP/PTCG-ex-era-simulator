@icon("res://Art/ExpansionIcons/40px-SetSymbolFireRed_and_LeafGreen.png")
extends Control
class_name UI_Slot

#--------------------------------------
#region VARIABLES
@export var active: bool = true
@export var player: bool = true
@export var home: bool = true
@export_enum("Left","Right","Up","Down") var list_direction: int = 0

@onready var name_section: RichTextLabel = %Name
@onready var max_hp: RichTextLabel = %MaxHP
@onready var tool: TextureRect = %Tool
@onready var tm: TextureRect = %TM
@onready var imprison = %Imprison
@onready var shockwave: TextureRect = %Shockwave
@onready var typeContainer: Array[Node] = %TypeContainer.get_children()
@onready var energyContainer: Array[Node] = %EnergyTypes.get_children()
@onready var list_offsets: Array[Vector2] = [Vector2(-size.x / 2, 0),
 Vector2(size.x / 2,0), Vector2(0,-size.y / 2), Vector2(0,size.y / 2)]

#Unfinished, doesn't account for special energy
var connected_slot: PokeSlot = PokeSlot.new()
var attached_energy: Dictionary = {"Grass": 0, "Fire": 0, "Water": 0,
 "Lightning": 0, "Psychic":0, "Darkness":0, "Metal":0, "Colorless":0,
 "Rainbow":0, "Magma":0, "Aqua":0, "Dark Metal":0, "React": 0,
 "Holon FF": 0, "Holon GL": 0, "Holon WP": 0}
var current_display: Node

#endregion
#--------------------------------------
# Called when the node enters the scene tree for the first time.
func _ready():
	%ArtButton.spawn_direction = list_direction
	if %ArtButton.benched: %ArtButton/PanelContainer.size = Vector2(149, 96)
	clear()
	connected_slot.slot_into(self)
	%ArtButton.connected_ui = self

#--------------------------------------
#region ATTATCH
func attatch_pokeslot(slot: PokeSlot):
	connected_slot = slot
	slot.slot_into(self)
	slot.refresh()

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
	print(energy_arr, energy_dict, energyContainer)
	%EnergyTypes.display_energy(energy_arr, energy_dict)
	#for node in energyContainer:
		#node.hide()
		#node.number = 0
	#
	#if energy_arr.size() > energyContainer.size():
		#var total_size = energy_arr.size()
		#var total_types: int = 0
		#print("COMPRESSED ADD")
		#for type in energy_dict:
			#if total_types > energyContainer.size() - 1:
				#energyContainer[-1].make_misc(total_size)
				#break
			#elif energy_dict[type] > 0:
				#energyContainer[total_types].add_type(type, energy_dict[type])
				#total_types += 1
				#total_size -= energy_dict[type]
	#else:
		#print("REGULAR ADD")
		#for i in range(energy_arr.size()):
			#print("ADD", energy_arr[i])
			#energyContainer[i].add_type(energy_arr[i])

#endregion
#--------------------------------------

#--------------------------------------
#region CONDITION DISPLAY
func display_condition() -> void:
	if connected_slot.poison_condition != 0:
		%Poison.show()
	elif active: %Poison.hide()
	
	if connected_slot.burn_condition != 0:
		%Burn.show()
	elif active: %Burn.hide()
	
	if connected_slot.turn_condition != 0:
		%TurnConditions.show()
		%TurnConditions.current_tab = connected_slot.turn_condition - 1

	elif active: %TurnConditions.hide()

func display_imprision(truth: bool = true) -> void:
	if truth: %Imprison.show()
	else: %Imprison.hide()

func display_shockwave(truth: bool = true) -> void:
	if truth: %Shockwave.show()
	else: %Shockwave.hide()

#endregion
#--------------------------------------

func switch_shine(value: bool):
	%ArtButton.material.set_shader_parameter("shine_bool", value)

func make_allowed(is_allowed: bool):
	%ArtButton.disabled = not is_allowed

func display_image(card: Base_Card):
	%ArtButton.current_card = card

func clear():
	name_section.clear()
	max_hp.clear()
	display_image(null)
	display_types([])
	tm.hide()
	tool.hide()
	display_condition()
	display_imprision(false)
	display_shockwave(false)
