@icon("res://Art/Energy/35px-Rainbow-attack.png")
extends Control

@export var en_count: int = 7

@onready var container: HBoxContainer = %Container

var energyContainer: Array[TypeContainer]
var current_indexes: Array

func _ready() -> void:
	current_indexes = range(en_count)
	
	for i in container.get_child_count():
		energyContainer.append(container.get_child(i))
		container.get_child(i).hide()

#--------------------------------------
#region ENERGY DISPLAY
func display_energy(energy_arr: Array, energy_dict: Dictionary):
	var total_types: int = 0
	for node in energyContainer:
		node.hide()
		node.number = 0
	
	if energy_arr.size() > en_count:
		print("COMPRESSED ADD")
		for type in energy_dict:
			if energy_dict[type] > 0:
				energyContainer[total_types].add_type(type, energy_dict[type])
				total_types += 1
				if total_types > en_count:
					energyContainer[total_types - 1].hide()
		
	if total_types > en_count - 1:
		%Timer.start()
	else:
		print("REGULAR ADD")
		for i in range(energy_arr.size()):
			print("ADD", energy_arr[i])
			energyContainer[i].add_type(energy_arr[i])
	
	if_nothing_in()

func if_nothing_in():
	var result: bool = false
	for node in energyContainer:
		result = result or node.number > 0
	
	visible = result
#endregion
#--------------------------------------

#--------------------------------------
#region SIGNALS
func _on_button_pressed() -> void:
	SignalBus.show_energy_attatched.emit((owner as UI_Slot).connected_slot)

func _on_timer_timeout() -> void:
	var next_index: int = (current_indexes[-1] + 1) % energyContainer.size()
	energyContainer[current_indexes.pop_front()].hide()
	
	if energyContainer[next_index].number == 0:
		next_index = 0
	
	current_indexes.append(next_index)
	energyContainer[current_indexes[-1]].show()

	#Move the current shown to the top based on order
	for i in range(en_count):
		var type: TypeContainer = energyContainer[current_indexes[i]]
		container.move_child(type, i)
#endregion
#--------------------------------------
