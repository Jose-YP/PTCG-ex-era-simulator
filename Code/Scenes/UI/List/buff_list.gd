extends Control

@export var change: SlotChange

func determine_change():
	print(change.get_script().get_global_name())
	match change.get_script().get_global_name():
		"Buff":
			pass
		"Disable":
			pass
		"Overwrite":
			pass
		"TypeChange":
			pass
	
