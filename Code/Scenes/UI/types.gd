extends Control

@export var energy: bool = false

var number: int = 0

func add_type(type: String):
	if visible and $Tabs.current_tab == Constants.find(type):
		number += 1
		$Number.clear()
		$Number.append_text(number)
		
		if number > 1:
			$Number.show()
		else:
			$Number.hide()

func display_type(type: String):
	$Tabs.current_tab = Constants.find(type)
