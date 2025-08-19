extends TabContainer

func display_buff(buff: Buff):
	var dict: Dictionary[String, bool] = buff.how_display()
	var key: String = dict.keys()[0]
	
	match key:
		"Atk":
			$Buffs.current_tab = 0
		"Def":
			$Buffs.current_tab = 1
		"HP":
			$Buffs.current_tab = 2
		"Cost":
			$Buffs.current_tab = 3
		_:
			push_error("I don't know what kind of buff this is")
	
	modulate = Color.AQUA if dict[key] else Color.ORANGE
