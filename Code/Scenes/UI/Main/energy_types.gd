extends GridContainer

@export var en_count: int = 8

var energyContainer: Array[TypeContainer]

func _ready() -> void:
	columns = en_count
	
	for i in get_child_count():
		energyContainer.append(get_child(i))
		if i > en_count - 1:
			get_child(i).hide()

func display_energy(energy_arr: Array, energy_dict: Dictionary):
	for node in energyContainer:
		node.hide()
		node.number = 0
	
	if energy_arr.size() > en_count:
		var total_size = energy_arr.size()
		var total_types: int = 0
		print("COMPRESSED ADD")
		for type in energy_dict:
			if total_types > en_count - 1:
				energyContainer[en_count - 1].make_misc(total_size)
				break
			elif energy_dict[type] > 0:
				energyContainer[total_types].add_type(type, energy_dict[type])
				total_types += 1
				total_size -= energy_dict[type]
	else:
		print("REGULAR ADD")
		for i in range(energy_arr.size()):
			print("ADD", energy_arr[i])
			energyContainer[i].add_type(energy_arr[i])
