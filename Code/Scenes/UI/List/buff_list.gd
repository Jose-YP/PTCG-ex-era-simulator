extends Control

@export var change: Resource

func determinechange():
	match change.get_class():
		"Buff":
			pass
		"Disable":
			pass
		"Overwrite":
			pass
		"TypeChange":
			pass
	
