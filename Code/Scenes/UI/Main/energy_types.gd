@icon("res://Art/Energy/35px-Rainbow-attack.png")
extends Control
class_name EnergyCollection

@export var en_count: int = 7
@export var align_right: bool = false
@export var disabled: bool = false

@onready var container: HBoxContainer = %Container
@onready var panel: PanelContainer = %Panel

var energy_container: Array[TypeContainer]
var current_indexes: Array

func _ready() -> void:
	current_indexes = range(en_count)
	if disabled:
		%Button.disabled = disabled
		%Button.mouse_filter = MOUSE_FILTER_IGNORE
	
	for i in container.get_child_count():
		energy_container.append(container.get_child(i))
		container.get_child(i).hide()
	
	if align_right:
		grow_horizontal = Control.GROW_DIRECTION_BEGIN

#--------------------------------------
#region ENERGY DISPLAY
func display_energy(energy_arr: Array, energy_dict: Dictionary):
	var total_types: int = 0
	for node in energy_container:
		node.hide()
		node.number = 0
	
	if energy_arr.size() > en_count:
		for type in energy_dict:
			if energy_dict[type] > 0:
				energy_container[total_types].add_type(type, energy_dict[type])
				total_types += 1
				if total_types > en_count:
					energy_container[total_types - 1].hide()
	else:
		for i in range(energy_arr.size()):
			energy_container[i].add_type(energy_arr[i])
	
	if total_types > en_count - 1:
		%Timer.start()
	
	if_nothing_in()

func reset_energy():
	for i in container.get_child_count():
		container.get_child(i).hide()

func if_nothing_in():
	var result: bool = false
	for node in energy_container:
		result = result or node.number > 0
	
	visible = result
#endregion
#--------------------------------------

#--------------------------------------
#region SIGNALS
func _on_button_pressed() -> void:
	SignalBus.show_energy_attatched.emit((owner as UI_Slot).connected_slot)

func _on_timer_timeout() -> void:
	var next_index: int = (current_indexes[-1] + 1) % energy_container.size()
	current_indexes.pop_front()
	if energy_container[next_index].number == 0:
		next_index = 0
	current_indexes.append(next_index)
	
	for node in energy_container:
		node.hide()
	#Move the current shown to the top based on order
	for i in range(en_count):
		var type: TypeContainer = energy_container[current_indexes[i]]
		container.move_child(type, i)
		type.show()
#endregion
#--------------------------------------
