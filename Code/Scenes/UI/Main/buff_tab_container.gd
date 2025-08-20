extends TabContainer

func display_change(change: SlotChange):
	var dict: Dictionary[String, bool] = change.how_display()
	var key: String = dict.keys()[0]
	
	match key:
		"Atk":
			current_tab = 0
		"Def":
			current_tab = 1
		"HP":
			current_tab = 2
		"Cost":
			current_tab = 3
		"Disable":
			current_tab = 4
		_:
			push_error("I don't know what kind of buff this is")
	
	modulate = Color.AQUA if dict[key] else Color.ORANGE
